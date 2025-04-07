# app.py
from flask import Flask, render_template, request, redirect, url_for, flash, session
from flask_mysqldb import MySQL
from werkzeug.security import generate_password_hash, check_password_hash
import os
from dotenv import load_dotenv
from config import Config

# Cargar variables de entorno
load_dotenv()

app = Flask(__name__)
app.config.from_object(Config)

# Configuración de la base de datos
mysql = MySQL(app)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/services')
def services():
    # Obtener servicios desde la base de datos
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM services")
    services = cur.fetchall()
    cur.close()
    return render_template('services.html', services=services)

@app.route('/contact', methods=['GET', 'POST'])
def contact():
    if request.method == 'POST':
        # Obtener datos del formulario
        name = request.form['name']
        email = request.form['email']
        message = request.form['message']
        
        # Guardar en la base de datos
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO contact_messages (name, email, message) VALUES (%s, %s, %s)",
                   (name, email, message))
        mysql.connection.commit()
        cur.close()
        
        flash('Mensaje enviado correctamente. Nos pondremos en contacto pronto.')
        return redirect(url_for('contact'))
        
    return render_template('contact.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        # Obtener datos del formulario
        email = request.form['email']
        password = request.form['password']
        
        # Verificar credenciales
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM users WHERE email = %s", (email,))
        user = cur.fetchone()
        cur.close()
        
        if user and check_password_hash(user[3], password):
            # Iniciar sesión
            session['logged_in'] = True
            session['user_id'] = user[0]
            session['name'] = user[1]
            
            flash('Has iniciado sesión correctamente')
            return redirect(url_for('dashboard'))
        else:
            flash('Email o contraseña incorrectos')
            
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.clear()
    flash('Has cerrado sesión correctamente')
    return redirect(url_for('index'))

@app.route('/dashboard')
def dashboard():
    if not session.get('logged_in'):
        flash('Debes iniciar sesión para acceder al dashboard')
        return redirect(url_for('login'))
    
    # Obtener datos para el dashboard
    cur = mysql.connection.cursor()
    cur.execute("SELECT COUNT(*) FROM clients")
    clients_count = cur.fetchone()[0]
    
    cur.execute("SELECT COUNT(*) FROM projects")
    projects_count = cur.fetchone()[0]
    
    cur.execute("""
        SELECT p.name, p.description, c.name as client_name, p.status
        FROM projects p
        JOIN clients c ON p.client_id = c.id
        ORDER BY p.created_at DESC
        LIMIT 5
    """)
    recent_projects = cur.fetchall()
    
    cur.close()
    
    return render_template('dashboard.html', 
                          clients_count=clients_count,
                          projects_count=projects_count,
                          recent_projects=recent_projects)

if __name__ == '__main__':
    app.run(debug=True)

# config.py
import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'clave-secreta-por-defecto'
    MYSQL_HOST = os.environ.get('MYSQL_HOST')
    MYSQL_USER = os.environ.get('MYSQL_USER')
    MYSQL_PASSWORD = os.environ.get('MYSQL_PASSWORD')
    MYSQL_DB = os.environ.get('MYSQL_DB')

# models/models.py
from app import mysql

class User:
    @staticmethod
    def get_by_id(user_id):
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM users WHERE id = %s", (user_id,))
        user = cur.fetchone()
        cur.close()
        return user
        
    @staticmethod
    def get_by_email(email):
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM users WHERE email = %s", (email,))
        user = cur.fetchone()
        cur.close()
        return user
        
    @staticmethod
    def create(name, email, password, role='user'):
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO users (name, email, password, role) VALUES (%s, %s, %s, %s)",
                   (name, email, password, role))
        mysql.connection.commit()
        user_id = cur.lastrowid
        cur.close()
        return user_id

class Client:
    @staticmethod
    def get_all():
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM clients")
        clients = cur.fetchall()
        cur.close()
        return clients
        
    @staticmethod
    def get_by_id(client_id):
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM clients WHERE id = %s", (client_id,))
        client = cur.fetchone()
        cur.close()
        return client

class Project:
    @staticmethod
    def get_all():
        cur = mysql.connection.cursor()
        cur.execute("""
            SELECT p.*, c.name as client_name
            FROM projects p
            JOIN clients c ON p.client_id = c.id
        """)
        projects = cur.fetchall()
        cur.close()
        return projects
        
    @staticmethod
    def get_by_id(project_id):
        cur = mysql.connection.cursor()
        cur.execute("""
            SELECT p.*, c.name as client_name
            FROM projects p
            JOIN clients c ON p.client_id = c.id
            WHERE p.id = %s
        """, (project_id,))
        project = cur.fetchone()
        cur.close()
        return project
