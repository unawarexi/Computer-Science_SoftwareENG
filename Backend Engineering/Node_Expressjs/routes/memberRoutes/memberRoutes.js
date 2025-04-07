
const express = require('express');
const router = express.Router();
const authenticate = require('../../controllers/auth/authentication');
const {
  createMember,
  getAllMembers,
  getMemberById,
  updateMember,
  deleteMember
} = require('../../controllers/memberController/membersController');


router.post('/members', authenticate, createMember);
router.get('/members', getAllMembers);
router.get('/members/:id', getMemberById);
router.put('/members/:id', authenticate, updateMember);
router.delete('/members/:id', authenticate, deleteMember);
module.exports = router;
