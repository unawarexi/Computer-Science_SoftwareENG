// controllers/chatController.js
const Chat = require('../../models/chatModel');
const User = require('../../models/authModel');
const UserStatus = require('../../models/UserStatus');
const mongoose = require('mongoose');

// Get all chats for a user
exports.getUserChats = async (req, res) => {
  try {
    const userId = req.user.id;
    
    // Find all chats where the user is a participant
    const chats = await Chat.find({
      participants: mongoose.Types.ObjectId(userId)
    })
    .populate('participants', 'firstName lastName email profilePicture')
    .sort({ updatedAt: -1 });
    
    // Add additional information to each chat for UI rendering
    const processedChats = await Promise.all(chats.map(async (chat) => {
      // Get user status for all participants
      const participantIds = chat.participants
        .filter(p => p._id.toString() !== userId)
        .map(p => p._id);
      
      const userStatuses = await UserStatus.find({
        user: { $in: participantIds }
      });
      
      // Create a map of user statuses for easy lookup
      const statusMap = {};
      userStatuses.forEach(status => {
        statusMap[status.user.toString()] = {
          isOnline: status.isOnline,
          lastSeen: status.lastSeen,
          currentStatus: status.currentStatus
        };
      });
      
      // Determine chat name based on type
      let chatName = '';
      let otherUser = null;
      
      if (chat.isGroupChat) {
        chatName = chat.groupName;
      } else {
        // For one-on-one chats, use the other user's name
        otherUser = chat.participants.find(p => p._id.toString() !== userId);
        if (otherUser) {
          chatName = `${otherUser.firstName} ${otherUser.lastName}`;
        }
      }
      
      // Get last message details
      let lastMessage = null;
      if (chat.messages && chat.messages.length > 0) {
        const message = chat.messages[chat.messages.length - 1];
        const sender = chat.participants.find(p => p._id.toString() === message.sender.toString());
        
        lastMessage = {
          _id: message._id,
          text: message.text,
          sender: sender ? {
            _id: sender._id,
            name: `${sender.firstName} ${sender.lastName}`
          } : { _id: message.sender, name: 'Unknown' },
          isRead: message.isRead,
          createdAt: message.createdAt
        };
      }
      
      // Count unread messages for this user
      const unreadCount = chat.messages.filter(
        m => m.sender.toString() !== userId && !m.isRead
      ).length;
      
      return {
        _id: chat._id,
        chatName,
        isGroupChat: chat.isGroupChat,
        participants: chat.participants.map(p => ({
          _id: p._id,
          name: `${p.firstName} ${p.lastName}`,
          profilePicture: p.profilePicture,
          isOnline: statusMap[p._id.toString()]?.isOnline || false,
          lastSeen: statusMap[p._id.toString()]?.lastSeen,
          currentStatus: statusMap[p._id.toString()]?.currentStatus || 'offline'
        })),
        lastMessage,
        unreadCount,
        updatedAt: chat.updatedAt,
        createdAt: chat.createdAt
      };
    }));
    
    res.status(200).json({
      success: true,
      count: processedChats.length,
      data: processedChats
    });
  } catch (error) {
    console.error('Error in getUserChats:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
};

// Get single chat by ID
exports.getChatById = async (req, res) => {
  try {
    const userId = req.user.id;
    const chatId = req.params.id;
    
    const chat = await Chat.findById(chatId)
      .populate('participants', 'firstName lastName email profilePicture');
    
    if (!chat) {
      return res.status(404).json({
        success: false,
        message: 'Chat not found'
      });
    }
    
    // Check if user is a participant
    if (!chat.participants.some(p => p._id.toString() === userId)) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to access this chat'
      });
    }
    
    // Get chat name based on type
    let chatName = '';
    if (chat.isGroupChat) {
      chatName = chat.groupName;
    } else {
      // For one-on-one chats, use the other user's name
      const otherUser = chat.participants.find(p => p._id.toString() !== userId);
      if (otherUser) {
        chatName = `${otherUser.firstName} ${otherUser.lastName}`;
      }
    }
    
    // Get participant statuses
    const participantIds = chat.participants
      .filter(p => p._id.toString() !== userId)
      .map(p => p._id);
    
    const userStatuses = await UserStatus.find({
      user: { $in: participantIds }
    });
    
    // Create a map of user statuses for easy lookup
    const statusMap = {};
    userStatuses.forEach(status => {
      statusMap[status.user.toString()] = {
        isOnline: status.isOnline,
        lastSeen: status.lastSeen,
        currentStatus: status.currentStatus
      };
    });
    
    // Format the response
    const formattedChat = {
      _id: chat._id,
      chatName,
      isGroupChat: chat.isGroupChat,
      participants: chat.participants.map(p => ({
        _id: p._id,
        name: `${p.firstName} ${p.lastName}`,
        profilePicture: p.profilePicture,
        isOnline: statusMap[p._id.toString()]?.isOnline || false,
        lastSeen: statusMap[p._id.toString()]?.lastSeen,
        currentStatus: statusMap[p._id.toString()]?.currentStatus || 'offline'
      })),
      messages: chat.messages.map(message => {
        const sender = chat.participants.find(p => p._id.toString() === message.sender.toString());
        return {
          _id: message._id,
          text: message.text,
          sender: sender ? {
            _id: sender._id,
            name: `${sender.firstName} ${sender.lastName}`,
            profilePicture: sender.profilePicture
          } : { _id: message.sender, name: 'Unknown' },
          media: message.media,
          mediaType: message.mediaType,
          isRead: message.isRead,
          readAt: message.readAt,
          createdAt: message.createdAt
        };
      }),
      updatedAt: chat.updatedAt,
      createdAt: chat.createdAt
    };

    res.status(200).json({
      success: true,
      data: formattedChat
    });
  } catch (error) {
    console.error('Error in getChatById:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
};

// Create a new chat (one-on-one or group)
exports.createChat = async (req, res) => {
  try {
    const { participantIds, isGroupChat, groupName } = req.body;
    const userId = req.user.id;

    if (!participantIds || !Array.isArray(participantIds) || participantIds.length === 0) {
      return res.status(400).json({ success: false, message: 'Participants required' });
    }

    // For one-on-one chat, check if chat already exists
    if (!isGroupChat && participantIds.length === 1) {
      const existingChat = await Chat.findOne({
        isGroupChat: false,
        participants: { $all: [userId, participantIds[0]], $size: 2 }
      });
      if (existingChat) {
        return res.status(200).json({ success: true, data: existingChat });
      }
    }

    // Create new chat
    const chat = new Chat({
      participants: [userId, ...participantIds.filter(id => id !== userId)],
      isGroupChat: !!isGroupChat,
      groupName: isGroupChat ? groupName : null,
      groupAdmin: isGroupChat ? userId : null
    });

    await chat.save();

    const populatedChat = await Chat.findById(chat._id)
      .populate('participants', 'firstName lastName email profilePicture');

    res.status(201).json({ success: true, data: populatedChat });
  } catch (error) {
    console.error('Error in createChat:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

// Send a message in a chat
exports.sendMessage = async (req, res) => {
  try {
    const userId = req.user.id;
    const chatId = req.params.id;
    const { text, media, mediaType } = req.body;

    if (!text && !media) {
      return res.status(400).json({ success: false, message: 'Message text or media required' });
    }

    const chat = await Chat.findById(chatId);
    if (!chat) {
      return res.status(404).json({ success: false, message: 'Chat not found' });
    }

    if (!chat.participants.some(p => p.toString() === userId)) {
      return res.status(403).json({ success: false, message: 'Not authorized' });
    }

    const message = {
      sender: userId,
      text: text || '',
      media: media || null,
      mediaType: mediaType || null,
      isRead: false,
      createdAt: new Date()
    };

    chat.messages.push(message);
    chat.updatedAt = new Date();
    await chat.save();

    // Optionally, populate sender info for response
    const populatedChat = await Chat.findById(chatId)
      .populate('participants', 'firstName lastName email profilePicture');

    res.status(201).json({ success: true, data: populatedChat.messages[chat.messages.length - 1] });
  } catch (error) {
    console.error('Error in sendMessage:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

// Mark messages as read in a chat
exports.markMessagesAsRead = async (req, res) => {
  try {
    const userId = req.user.id;
    const chatId = req.params.id;

    const chat = await Chat.findById(chatId);
    if (!chat) {
      return res.status(404).json({ success: false, message: 'Chat not found' });
    }

    let updatedCount = 0;
    chat.messages.forEach(msg => {
      if (msg.sender.toString() !== userId && !msg.isRead) {
        msg.isRead = true;
        msg.readAt = new Date();
        updatedCount++;
      }
    });

    if (updatedCount > 0) {
      chat.updatedAt = new Date();
      await chat.save();
    }

    res.status(200).json({ success: true, updatedCount });
  } catch (error) {
    console.error('Error in markMessagesAsRead:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

// Add participant to group chat
exports.addParticipant = async (req, res) => {
  try {
    const userId = req.user.id;
    const chatId = req.params.id;
    const { participantId } = req.body;

    const chat = await Chat.findById(chatId);
    if (!chat || !chat.isGroupChat) {
      return res.status(404).json({ success: false, message: 'Group chat not found' });
    }

    if (chat.groupAdmin.toString() !== userId) {
      return res.status(403).json({ success: false, message: 'Only group admin can add participants' });
    }

    if (chat.participants.includes(participantId)) {
      return res.status(400).json({ success: false, message: 'User already in group' });
    }

    chat.participants.push(participantId);
    chat.updatedAt = new Date();
    await chat.save();

    res.status(200).json({ success: true, data: chat });
  } catch (error) {
    console.error('Error in addParticipant:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

// Remove participant from group chat
exports.removeParticipant = async (req, res) => {
  try {
    const userId = req.user.id;
    const chatId = req.params.id;
    const { participantId } = req.body;

    const chat = await Chat.findById(chatId);
    if (!chat || !chat.isGroupChat) {
      return res.status(404).json({ success: false, message: 'Group chat not found' });
    }

    if (chat.groupAdmin.toString() !== userId && participantId !== userId) {
      return res.status(403).json({ success: false, message: 'Only group admin can remove others' });
    }

    chat.participants = chat.participants.filter(p => p.toString() !== participantId);
    chat.updatedAt = new Date();
    await chat.save();

    res.status(200).json({ success: true, data: chat });
  } catch (error) {
    console.error('Error in removeParticipant:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

// Update group name
exports.updateGroupName = async (req, res) => {
  try {
    const userId = req.user.id;
    const chatId = req.params.id;
    const { groupName } = req.body;

    const chat = await Chat.findById(chatId);
    if (!chat || !chat.isGroupChat) {
      return res.status(404).json({ success: false, message: 'Group chat not found' });
    }

    if (chat.groupAdmin.toString() !== userId) {
      return res.status(403).json({ success: false, message: 'Only group admin can update group name' });
    }

    chat.groupName = groupName;
    chat.updatedAt = new Date();
    await chat.save();

    res.status(200).json({ success: true, data: chat });
  } catch (error) {
    console.error('Error in updateGroupName:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

// Delete a chat (only for group admin or one-on-one participants)
exports.deleteChat = async (req, res) => {
  try {
    const userId = req.user.id;
    const chatId = req.params.id;

    const chat = await Chat.findById(chatId);
    if (!chat) {
      return res.status(404).json({ success: false, message: 'Chat not found' });
    }

    if (chat.isGroupChat) {
      if (chat.groupAdmin.toString() !== userId) {
        return res.status(403).json({ success: false, message: 'Only group admin can delete group chat' });
      }
    } else {
      if (!chat.participants.some(p => p.toString() === userId)) {
        return res.status(403).json({ success: false, message: 'Not authorized' });
      }
    }

    await Chat.findByIdAndDelete(chatId);

    res.status(200).json({ success: true, message: 'Chat deleted' });
  } catch (error) {
    console.error('Error in deleteChat:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};