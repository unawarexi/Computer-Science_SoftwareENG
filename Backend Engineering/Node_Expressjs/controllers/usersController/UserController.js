// controllers/userController.js
const User = require('../../models/authModel');

// Get all users (admin only)
exports.getAllUsers = async (req, res) => {
  try {
    const users = await User.find();
    
    res.status(200).json({
      status: 'success',
      results: users.length,
      data: {
        users
      }
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: error.message
    });
  }
};

// Get user by ID
exports.getUser = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    
    if (!user) {
      return res.status(404).json({
        status: 'fail',
        message: 'No user found with that ID'
      });
    }
    
    res.status(200).json({
      status: 'success',
      data: {
        user
      }
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: error.message
    });
  }
};

// Get current user profile
exports.getMe = async (req, res, next) => {
  try {
    const user = await User.findById(req.user.id);
    
    res.status(200).json({
      status: 'success',
      data: {
        user
      }
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: error.message
    });
  }
};

// Update user
exports.updateUser = async (req, res) => {
  try {
    // Don't allow password updates through this route
    if (req.body.password) {
      return res.status(400).json({
        status: 'fail',
        message: 'This route is not for password updates. Please use /updateMyPassword'
      });
    }
    
    // Filter out unwanted field names that aren't allowed to be updated
    const filteredBody = filterObj(req.body, 'firstName', 'lastName', 'email', 'profilePicture');
    
    // Update user document
    const updatedUser = await User.findByIdAndUpdate(req.params.id, filteredBody, {
      new: true,
      runValidators: true
    });
    
    if (!updatedUser) {
      return res.status(404).json({
        status: 'fail',
        message: 'No user found with that ID'
      });
    }
    
    res.status(200).json({
      status: 'success',
      data: {
        user: updatedUser
      }
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: error.message
    });
  }
};

// Update current user profile
exports.updateMe = async (req, res, next) => {
  try {
    // Don't allow password updates through this route
    if (req.body.password) {
      return res.status(400).json({
        status: 'fail',
        message: 'This route is not for password updates. Please use /updateMyPassword'
      });
    }
    
    // Filter out unwanted field names that aren't allowed to be updated
    const filteredBody = filterObj(req.body, 'firstName', 'lastName', 'email', 'profilePicture');
    
    // Update user document
    const updatedUser = await User.findByIdAndUpdate(req.user.id, filteredBody, {
      new: true,
      runValidators: true
    });
    
    res.status(200).json({
      status: 'success',
      data: {
        user: updatedUser
      }
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: error.message
    });
  }
};

// Delete user
exports.deleteUser = async (req, res) => {
  try {
    const user = await User.findByIdAndDelete(req.params.id);
    
    if (!user) {
      return res.status(404).json({
        status: 'fail',
        message: 'No user found with that ID'
      });
    }
    
    res.status(204).json({
      status: 'success',
      data: null
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: error.message
    });
  }
};

// Delete current user (set inactive)
exports.deleteMe = async (req, res, next) => {
  try {
    await User.findByIdAndDelete(req.user.id);
    
    res.status(204).json({
      status: 'success',
      data: null
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: error.message
    });
  }
};

// Helper function to filter object
const filterObj = (obj, ...allowedFields) => {
  const newObj = {};
  Object.keys(obj).forEach(el => {
    if (allowedFields.includes(el)) newObj[el] = obj[el];
  });
  return newObj;
};