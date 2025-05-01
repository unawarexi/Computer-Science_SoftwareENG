// models/Call.js
const mongoose = require('mongoose');

const callSchema = new mongoose.Schema({
  caller: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  receiver: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  startTime: {
    type: Date,
    default: Date.now
  },
  endTime: {
    type: Date,
    default: null
  },
  duration: {
    type: Number,
    default: 0 // Duration in seconds
  },
  type: {
    type: String,
    enum: ['audio', 'video'],
    required: true
  },
  status: {
    type: String,
    enum: ['initiated', 'ringing', 'ongoing', 'completed', 'missed', 'rejected'],
    default: 'initiated'
  },
  mediaConnectionId: {
    type: String,
    default: null // For storing WebRTC connection ID
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

// Create indexes for efficient querying
callSchema.index({ caller: 1, createdAt: -1 });
callSchema.index({ receiver: 1, createdAt: -1 });
callSchema.index({ status: 1 });

// Method to calculate call duration when ended
callSchema.methods.calculateDuration = function() {
  if (this.endTime && this.startTime) {
    this.duration = Math.round((this.endTime - this.startTime) / 1000);
  }
  return this.duration;
};

// Method to end a call and calculate duration
callSchema.methods.endCall = function(status = 'completed') {
  this.endTime = new Date();
  this.status = status;
  this.calculateDuration();
  return this;
};

const Call = mongoose.model('Call', callSchema);

module.exports = Call;