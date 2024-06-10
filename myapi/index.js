const express = require('express');
const app = express();
const port = 3000;

app.use(express.json());

// Deklarasikan dan inisialisasi variabel complaintReports
let complaintReports = [];

// Pengaduan dan Laporan
app.get('/complaint-reports', (req, res) => {
  res.json(complaintReports);
});

app.post('/complaint-reports', (req, res) => {
  const newComplaint = req.body;
  newComplaint.id = complaintReports.length + 1; // Assign ID
  complaintReports.push(newComplaint);
  res.status(201).json(newComplaint);
});

app.put('/complaint-reports/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const updatedComplaint = req.body;
  complaintReports = complaintReports.map(complaint => complaint.id === id ? updatedComplaint : complaint);
  res.json(updatedComplaint);
});

app.delete('/complaint-reports/:id', (req, res) => {
  const id = parseInt(req.params.id);
  complaintReports = complaintReports.filter(complaint => complaint.id !== id);
  res.status(204).end();
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
