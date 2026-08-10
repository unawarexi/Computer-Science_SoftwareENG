// controllers/controller.js
const members = require("../../data/members")
  // CREATE: Add a new member
  const createMember = async (req, res) => {
    try {
      const { name, age, is_online, occupation } = req.body;
      if (!name || !age || !occupation) {
        return res.status(400).json({ error: 'Name, age, and occupation are required' });
      }
  
      const newMember = {
        id: members.length + 1,  // Generate a new id
        name,
        age,
        is_online,
        occupation
      };
  
      members.push(newMember);
      res.status(201).json(newMember);
    } catch (error) {
      res.status(500).json({ error: 'Failed to create new member' });
    }
  };
  
  // READ: Get all members
  const getAllMembers = async (req, res) => {
    try {
      res.json(members);
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch members' });
    }
  };
  
  // READ: Get a member by ID
  const getMemberById = async (req, res) => {
    try {
      const member = members.find(m => m.id === parseInt(req.params.id));
      if (!member) {
        return res.status(404).json({ error: 'Member not found' });
      }
      res.json(member);
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch member' });
    }
  };
  
  // UPDATE: Update a member by ID
  const updateMember = async (req, res) => {
    try {
      const member = members.find(m => m.id === parseInt(req.params.id));
      if (!member) {
        return res.status(404).json({ error: 'Member not found' });
      }
  
      const { name, age, is_online, occupation } = req.body;
      member.name = name || member.name;
      member.age = age || member.age;
      member.is_online = is_online !== undefined ? is_online : member.is_online;
      member.occupation = occupation || member.occupation;
  
      res.json(member);
    } catch (error) {
      res.status(500).json({ error: 'Failed to update member' });
    }
  };
  
  // DELETE: Delete a member by ID
  const deleteMember = async (req, res) => {
    try {
      const memberIndex = members.findIndex(m => m.id === parseInt(req.params.id));
      if (memberIndex === -1) {
        return res.status(404).json({ error: 'Member not found' });
      }
  
      members.splice(memberIndex, 1);
      res.status(204).send();
    } catch (error) {
      res.status(500).json({ error: 'Failed to delete member' });
    }
  };
  
  module.exports = {
    createMember,
    getAllMembers,
    getMemberById,
    updateMember,
    deleteMember
  };
  