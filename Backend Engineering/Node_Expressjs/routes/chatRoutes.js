const express = require('express');
const router = express.Router();
const chatController = require('../controllers/communications/chatController');
const { protect } = require('../middleware/authMiddleware');

// Get all chats for the logged-in user
router.get('/', protect, chatController.getUserChats);

// Get a single chat by ID
router.get('/:id', protect, chatController.getChatById);

// Create a new chat (one-on-one or group)
router.post('/', protect, chatController.createChat);

// Send a message in a chat
router.post('/:id/messages', protect, chatController.sendMessage);

// Mark messages as read in a chat
router.post('/:id/read', protect, chatController.markMessagesAsRead);

// Add participant to group chat
router.post('/:id/add-participant', protect, chatController.addParticipant);

// Remove participant from group chat
router.post('/:id/remove-participant', protect, chatController.removeParticipant);

// Update group name
router.patch('/:id/group-name', protect, chatController.updateGroupName);

// Delete a chat
router.delete('/:id', protect, chatController.deleteChat);

module.exports = router;
