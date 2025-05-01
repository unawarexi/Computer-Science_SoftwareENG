// models/UserStatus.js
const mongoose = require('mongoose');

const userStatusSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    unique: true
  },
  isOnline: {
    type: Boolean,
    default: false
  },
  lastSeen: {
    type: Date,
    default: Date.now
  },
  socketId: {
    type: String,
    default: null
  },
  currentStatus: {
    type: String,
    enum: ['available', 'busy', 'away', 'offline'],
    default: 'available'
  },
  device: {
    type: String,
    enum: ['mobile', 'web', 'desktop', null],
    default: null
  },
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
}, { 
  timestamps: true 
});

// Create index for efficient lookup
userStatusSchema.index({ user: 1 });
userStatusSchema.index({ isOnline: 1 });

// Method to update user's online status
userStatusSchema.methods.updateOnlineStatus = function(isOnline, socketId = null) {
  this.isOnline = isOnline;
  
  if (isOnline) {
    this.socketId = socketId;
    this.currentStatus = 'available';
  } else {
    this.lastSeen = new Date();
    this.socketId = null;
    this.currentStatus = 'offline';
  }
  
  return this;
};

const UserStatus = mongoose.model('UserStatus', userStatusSchema);

module.exports = UserStatus;