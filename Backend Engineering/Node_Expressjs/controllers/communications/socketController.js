// controllers/socketController.js
const User = require('../../models/authModel');
const Chat = require('../../models/chatModel');
const Call = require('../../models/callModel');
const UserStatus = require('../../models/UserStatus');
const jwt = require('jsonwebtoken');
const mongoose = require('mongoose');

class SocketController {
  constructor(io) {
    this.io = io;
    this.connectedUsers = new Map(); // userId -> socketId
    this.setupSocketEvents();
  }

  setupSocketEvents() {
    this.io.on('connection', async (socket) => {
      try {
        // Authenticate user from token
        const token = socket.handshake.auth.token;
        if (!token) {
          socket.disconnect();
          return;
        }

        // Verify JWT token
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const userId = decoded.id;
        const user = await User.findById(userId);
        
        if (!user) {
          socket.disconnect();
          return;
        }

        // Store connection
        socket.userId = userId;
        this.connectedUsers.set(userId, socket.id);
        
        // Update user status in database
        await UserStatus.findOneAndUpdate(
          { user: userId },
          { 
            isOnline: true,
            socketId: socket.id,
            lastSeen: new Date(),
            currentStatus: 'available'
          },
          { upsert: true, new: true }
        );

        // Emit to friends that this user is online
        this.emitUserStatusChange(userId, true);

        console.log(`User ${userId} connected with socket ${socket.id}`);
        
        // Set up event handlers for this socket
        this.setupUserEventHandlers(socket, userId);

      } catch (error) {
        console.error('Socket authentication error:', error);
        socket.disconnect();
      }
    });
  }

  setupUserEventHandlers(socket, userId) {
    // Message handling
    socket.on('send-message', async (data) => {
      try {
        await this.handleSendMessage(socket, userId, data);
      } catch (err) {
        console.error('Error in send-message event:', err);
        socket.emit('error', { message: 'Failed to send message' });
      }
    });

    // Read receipt handling
    socket.on('mark-read', async (data) => {
      try {
        await this.handleMarkRead(socket, userId, data);
      } catch (err) {
        console.error('Error in mark-read event:', err);
        socket.emit('error', { message: 'Failed to mark messages as read' });
      }
    });

    // Typing indicators
    socket.on('typing', (data) => {
      try {
        this.handleTypingIndicator(socket, userId, data, true);
      } catch (err) {
        console.error('Error in typing event:', err);
      }
    });

    socket.on('stop-typing', (data) => {
      try {
        this.handleTypingIndicator(socket, userId, data, false);
      } catch (err) {
        console.error('Error in stop-typing event:', err);
      }
    });

    // Call handling
    socket.on('call-request', async (data) => {
      try {
        await this.handleCallRequest(socket, userId, data);
      } catch (err) {
        console.error('Error in call-request event:', err);
        socket.emit('call-error', { message: 'Failed to initiate call' });
      }
    });

    socket.on('call-response', async (data) => {
      try {
        await this.handleCallResponse(socket, userId, data);
      } catch (err) {
        console.error('Error in call-response event:', err);
        socket.emit('call-error', { message: 'Failed to respond to call' });
      }
    });

    socket.on('end-call', async (data) => {
      try {
        await this.handleEndCall(socket, userId, data);
      } catch (err) {
        console.error('Error in end-call event:', err);
        socket.emit('call-error', { message: 'Failed to end call' });
      }
    });

    // WebRTC signaling
    socket.on('webrtc-signal', (data) => {
      const { receiverId, signal } = data;
      const receiverSocketId = this.connectedUsers.get(receiverId);
      
      if (receiverSocketId) {
        this.io.to(receiverSocketId).emit('webrtc-signal', {
          senderId: userId,
          signal
        });
      }
    });

    // User status updates
    socket.on('update-status', async (data) => {
      try {
        await this.handleStatusUpdate(socket, userId, data);
      } catch (err) {
        console.error('Error in update-status event:', err);
      }
    });

    // Disconnect handling
    socket.on('disconnect', async () => {
      try {
        await this.handleDisconnect(socket, userId);
      } catch (err) {
        console.error('Error in disconnect event:', err);
      }
    });
  }

  // Helper methods for handling specific events
  async handleSendMessage(socket, senderId, data) {
    const { chatId, receiverId, text, media, mediaType } = data;
    
    let chat;
    // If chatId is provided, use existing chat
    if (chatId) {
      chat = await Chat.findById(chatId);
      if (!chat) {
        throw new Error('Chat not found');
      }
      
      // Verify sender is a participant
      if (!chat.participants.includes(mongoose.Types.ObjectId(senderId))) {
        throw new Error('User not authorized for this chat');
      }
    } 
    // Otherwise create a new one-on-one chat
    else if (receiverId) {
      // Check if chat already exists between these users
      chat = await Chat.findOne({
        isGroupChat: false,
        participants: { 
          $all: [
            mongoose.Types.ObjectId(senderId), 
            mongoose.Types.ObjectId(receiverId)
          ],
          $size: 2
        }
      });
      
      // Create new chat if doesn't exist
      if (!chat) {
        chat = new Chat({
          participants: [senderId, receiverId],
          isGroupChat: false
        });
      }
    } else {
      throw new Error('Either chatId or receiverId must be provided');
    }
    
    // Create and add the new message
    const newMessage = {
      sender: senderId,
      text,
      media,
      mediaType,
      isRead: false,
      createdAt: new Date()
    };
    
    chat.messages.push(newMessage);
    chat.lastMessage = newMessage._id;
    chat.updatedAt = new Date();
    
    await chat.save();
    
    // Send message to all participants who are online
    chat.participants.forEach(participantId => {
      if (participantId.toString() !== senderId) {
        const socketId = this.connectedUsers.get(participantId.toString());
        if (socketId) {
          this.io.to(socketId).emit('new-message', {
            chatId: chat._id,
            message: {
              ...newMessage,
              _id: newMessage._id, // Ensure the generated ID is included
              sender: {
                _id: senderId,
                // Other sender info can be populated here if needed
              }
            }
          });
        }
      }
    });
    
    // Confirm to sender
    socket.emit('message-sent', {
      chatId: chat._id,
      messageId: newMessage._id,
      timestamp: newMessage.createdAt
    });
    
    return { chat, message: newMessage };
  }

  async handleMarkRead(socket, userId, data) {
    const { chatId, messageId } = data;
    
    const chat = await Chat.findById(chatId);
    if (!chat) {
      throw new Error('Chat not found');
    }
    
    // Verify user is a participant
    if (!chat.participants.some(p => p.toString() === userId)) {
      throw new Error('User not authorized for this chat');
    }
    
    // Mark specified message and all earlier unread messages as read
    let updated = false;
    if (messageId) {
      // Find the index of the specified message
      const messageIndex = chat.messages.findIndex(
        m => m._id.toString() === messageId
      );
      
      if (messageIndex !== -1) {
        // Mark this and all earlier messages as read
        for (let i = 0; i <= messageIndex; i++) {
          const message = chat.messages[i];
          if (message.sender.toString() !== userId && !message.isRead) {
            message.isRead = true;
            message.readAt = new Date();
            updated = true;
          }
        }
      }
    } else {
      // Mark all unread messages as read
      chat.messages.forEach(message => {
        if (message.sender.toString() !== userId && !message.isRead) {
          message.isRead = true;
          message.readAt = new Date();
          updated = true;
        }
      });
    }
    
    if (updated) {
      await chat.save();
      
      // Notify the senders of read messages
      const sendersToNotify = new Set();
      chat.messages.forEach(message => {
        if (message.isRead && message.readAt && message.sender.toString() !== userId) {
          sendersToNotify.add(message.sender.toString());
        }
      });
      
      sendersToNotify.forEach(senderId => {
        const socketId = this.connectedUsers.get(senderId);
        if (socketId) {
          this.io.to(socketId).emit('messages-read', {
            chatId,
            readBy: userId,
            timestamp: new Date()
          });
        }
      });
    }
    
    // Confirm to the reader
    socket.emit('marked-read', { chatId, success: true });
    
    return { success: true, updated };
  }

  handleTypingIndicator(socket, userId, data, isTyping) {
    const { chatId } = data;
    
    // Notify all other participants in the chat
    socket.to(chatId).emit(isTyping ? 'user-typing' : 'user-stopped-typing', {
      chatId,
      userId
    });
  }

  async handleCallRequest(socket, callerId, data) {
    const { receiverId, callType } = data;
    
    // Create a new call record
    const call = new Call({
      caller: callerId,
      receiver: receiverId,
      type: callType,
      status: 'initiated',
      startTime: new Date()
    });
    
    await call.save();
    
    // Get receiver's socket if online
    const receiverSocketId = this.connectedUsers.get(receiverId);
    
    if (receiverSocketId) {
      // Send call request to receiver
      this.io.to(receiverSocketId).emit('incoming-call', {
        callId: call._id,
        callerId,
        callType,
        timestamp: call.startTime
      });
      
      // Update call status to ringing
      call.status = 'ringing';
      await call.save();
    } else {
      // Receiver is offline, mark call as missed
      call.status = 'missed';
      call.endTime = new Date();
      call.calculateDuration();
      await call.save();
      
      // Notify caller that receiver is unavailable
      socket.emit('call-missed', {
        callId: call._id,
        reason: 'receiver_offline'
      });
    }
    
    return call;
  }

  async handleCallResponse(socket, responderId, data) {
    const { callId, accept } = data;
    
    const call = await Call.findById(callId);
    if (!call) {
      throw new Error('Call not found');
    }
    
    // Verify responder is the intended receiver
    if (call.receiver.toString() !== responderId) {
      throw new Error('Not authorized to respond to this call');
    }
    
    if (accept) {
      // Call accepted
      call.status = 'ongoing';
      await call.save();
      
      // Notify caller that call was accepted
      const callerSocketId = this.connectedUsers.get(call.caller.toString());
      if (callerSocketId) {
        this.io.to(callerSocketId).emit('call-accepted', {
          callId: call._id,
          receiverId: responderId
        });
      }
    } else {
      // Call rejected
      call.status = 'rejected';
      call.endTime = new Date();
      call.calculateDuration();
      await call.save();
      
      // Notify caller that call was rejected
      const callerSocketId = this.connectedUsers.get(call.caller.toString());
      if (callerSocketId) {
        this.io.to(callerSocketId).emit('call-rejected', {
          callId: call._id,
          receiverId: responderId
        });
      }
    }
    
    return call;
  }

  async handleEndCall(socket, userId, data) {
    const { callId } = data;
    
    const call = await Call.findById(callId);
    if (!call) {
      throw new Error('Call not found');
    }
    
    // Verify user is either caller or receiver
    if (call.caller.toString() !== userId && call.receiver.toString() !== userId) {
      throw new Error('Not authorized to end this call');
    }
    
    // End the call
    call.endCall('completed');
    await call.save();
    
    // Notify the other participant
    const otherUserId = call.caller.toString() === userId 
      ? call.receiver.toString() 
      : call.caller.toString();
    
    const otherSocketId = this.connectedUsers.get(otherUserId);
    if (otherSocketId) {
      this.io.to(otherSocketId).emit('call-ended', {
        callId: call._id,
        endedBy: userId,
        duration: call.duration
      });
    }
    
    return call;
  }

  async handleStatusUpdate(socket, userId, data) {
    const { status } = data;
    
    // Update user status in database
    const userStatus = await UserStatus.findOneAndUpdate(
      { user: userId },
      { currentStatus: status },
      { new: true }
    );
    
    // Broadcast status change to friends (simplified implementation)
    this.emitUserStatusChange(userId, userStatus.isOnline, status);
    
    return userStatus;
  }

  async handleDisconnect(socket, userId) {
    console.log(`User ${userId} disconnected`);
    
    // Remove from connected users map
    this.connectedUsers.delete(userId);
    
    // Update user status in database
    await UserStatus.findOneAndUpdate(
      { user: userId },
      { 
        isOnline: false,
        socketId: null,
        lastSeen: new Date(),
        currentStatus: 'offline'
      }
    );
    
    // Emit to friends that this user is offline
    this.emitUserStatusChange(userId, false);
  }

  // Helper method to broadcast user status changes
  emitUserStatusChange(userId, isOnline, status = null) {
    // In a real application, you'd fetch this user's friends
    // and emit only to them. This is a simplified version.
    this.io.emit('user-status-change', {
      userId,
      isOnline,
      status,
      lastSeen: isOnline ? null : new Date()
    });
  }
}

module.exports = SocketController;