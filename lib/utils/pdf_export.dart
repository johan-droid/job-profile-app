import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/resume.dart';
import '../models/user.dart';

class PdfExportService {
  Future<Uint8List> generateResumePdf(Resume resume, StudentProfile profile) async {
    final pdf = pw.Document();
    
    // Load fonts
    final ttf = await rootBundle.load("assets/fonts/OpenSans-Regular.ttf");
    final ttfBold = await rootBundle.load("assets/fonts/OpenSans-Bold.ttf");
    final font = pw.Font.ttf(ttf);
    final fontBold = pw.Font.ttf(ttfBold);
    
    // Choose template based on resume.template
    switch (resume.template) {
      case ResumeTemplate.modern:
        _buildModernTemplate(pdf, resume, profile, font, fontBold);
        break;
      case ResumeTemplate.classic:
        _buildClassicTemplate(pdf, resume, profile, font, fontBold);
        break;
      case ResumeTemplate.creative:
        _buildCreativeTemplate(pdf, resume, profile, font, fontBold);
        break;
      case ResumeTemplate.minimalist:
      default:
        _buildMinimalistTemplate(pdf, resume, profile, font, fontBold);
        break;
    }
    
    return pdf.save();
  }
  
  void _buildModernTemplate(
    pw.Document pdf, 
    Resume resume, 
    StudentProfile profile,
    pw.Font font,
    pw.Font fontBold,
  ) {
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                color: PdfColors.indigo700,
                padding: const pw.EdgeInsets.all(20),
                width: double.infinity,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      profile.name,
                      style: pw.TextStyle(
                        font: fontBold,
                        color: PdfColors.white,
                        fontSize: 24,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      resume.objective,
                      style: pw.TextStyle(
                        font: font,
                        color: PdfColors.white,
                        fontSize: 12,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          resume.contactInfo['email'] ?? '',
                          style: pw.TextStyle(
                            font: font,
                            color: PdfColors.white,
                            fontSize: 10,
                          ),
                        ),
                        pw.Text(
                          resume.contactInfo['phone'] ?? '',
                          style: pw.TextStyle(
                            font: font,
                            color: PdfColors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Education',
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 16,
                  color: PdfColors.indigo700,
                ),
              ),
              pw.Divider(color: PdfColors.indigo700),
              ...resume.education.map((edu) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      edu.institution,
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: 14,
                      ),
                    ),
                    pw.Text(
                      '${edu.degree} in ${edu.fieldOfStudy}',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 12,
                      ),
                    ),
                    pw.Text(
                      '${edu.startDate.year} - ${edu.endDate?.year ?? 'Present'}',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              )),
              pw.SizedBox(height: 20),
              pw.Text(
                'Experience',
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 16,
                  color: PdfColors.indigo700,
                ),
              ),
              pw.Divider(color: PdfColors.indigo700),
              ...resume.experience.map((exp) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      exp.company,
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: 14,
                      ),
                    ),
                    pw.Text(
                      exp.role,
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 12,
                      ),
                    ),
                    pw.Text(
                      '${exp.startDate.year} - ${exp.endDate?.year ?? 'Present'}',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.Text(
                      exp.description,
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              )),
              pw.SizedBox(height: 20),
              pw.Text(
                'Skills',
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 16,
                  color: PdfColors.indigo700,
                ),
              ),
              pw.Divider(color: PdfColors.indigo700),
              pw.Wrap(
                spacing: 5,
                runSpacing: 5,
                children: resume.skills.map((skill) => pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.indigo100,
                    borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.Text(
                    skill,
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 10,
                    ),
                  ),
                )).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
  
  void _buildClassicTemplate(
    pw.Document pdf, 
    Resume resume, 
    StudentProfile profile,
    pw.Font font,
    pw.Font fontBold,
  ) {
    // Simplified implementation - would include classic layout
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              'Classic Resume Template',
              style: pw.TextStyle(font: fontBold, fontSize: 24),
            ),
          );
        },
      ),
    );
  }
  
  void _buildCreativeTemplate(
    pw.Document pdf, 
    Resume resume, 
    StudentProfile profile,
    pw.Font font,
    pw.Font fontBold,
  ) {
    // Simplified implementation - would include creative layout
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              'Creative Resume Template',
              style: pw.TextStyle(font: fontBold, fontSize: 24),
            ),
          );
        },
      ),
    );
  }
  
  void _buildMinimalistTemplate(
    pw.Document pdf, 
    Resume resume, 
    StudentProfile profile,
    pw.Font font,
    pw.Font fontBold,
  ) {
    // Simplified implementation - would include minimalist layout
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              'Minimalist Resume Template',
              style: pw.TextStyle(font: fontBold, fontSize: 24),
            ),
          );
        },
      ),
    );
  }
}
