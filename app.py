from flask import Flask, render_template, request, redirect, url_for, flash
import psycopg2

app = Flask(__name__)
# app.secret_key = 'XXXX'

conn = psycopg2.connect(
    dbname="KIU_Stadiums",
    user="postgres",
    password="Anita202004.",
    host="localhost",
    port="5432"
)
cursor = conn.cursor()

@app.route('/')
def index():
    cursor.execute("SELECT id, description FROM stadiums;")
    stadiums = cursor.fetchall()
    return render_template('/templates/index.html', stadiums=stadiums)

@app.route('/reserve', methods=['POST'])
def reserve():
    student_id = request.form['student_id']
    stadium_id = request.form['stadium_id']
    starttime = request.form['starttime']
    endtime = request.form['endtime']

    try:
        cursor.execute("""
            INSERT INTO reservation (student_id, stadium_id, starttime, endtime)
            VALUES (%s, %s, %s, %s)
        """, (student_id, stadium_id, starttime, endtime))
        conn.commit()
        flash("Reservation successful!", "success")
    except Exception as e:
        conn.rollback()
        flash(f"Error: {str(e)}", "danger")

    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True)
