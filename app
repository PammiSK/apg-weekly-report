from flask import Flask, render_template, request, send_file
from docx import Document
import io

app = Flask(__name__)

QUESTIONS = [
    "1. What is your name?",
    "2. What is your role?",
    "3. Describe your main responsibilities:",
    "4. What goals did you achieve this week?"
]

@app.route("/", methods=["GET"])
def form():
    return render_template("form.html", questions=QUESTIONS)

@app.route("/generate", methods=["POST"])
def generate():
    answers = [request.form.get(f"q{i}") for i in range(len(QUESTIONS))]
    doc = Document()
    doc.add_heading("User Report", level=1)
    for idx, (q, a) in enumerate(zip(QUESTIONS, answers), start=1):
        doc.add_paragraph(f"{q}")
        doc.add_paragraph(f"Answer: {a}")
        if idx < len(QUESTIONS):
            doc.add_paragraph("")  # blank line between sections

    file_stream = io.BytesIO()
    doc.save(file_stream)
    file_stream.seek(0)

    return send_file(
        file_stream,
        as_attachment=True,
        download_name="report.docx",
        mimetype="application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    )

if __name__ == "__main__":
    app.run(debug=True)
