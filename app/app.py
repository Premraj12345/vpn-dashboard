from flask import Flask, render_template, send_file
from flask_socketio import SocketIO, emit
import os

app = Flask(__name__)
socketio = SocketIO(app)

# Serve the landing page
@app.route('/')
def index():
    return render_template('index.html')

# Serve the certificate download (static file)
@app.route('/download_cert')
def download_cert():
    return send_file('certs/vpn-cert.crt', as_attachment=True)

# Emit real-time logs when captured by mitmproxy
@socketio.on('get_logs')
def handle_log_request(data):
    # Simulate captured logs (mitmproxy integration would push real data)
    log_data = "Captured log data for device: " + str(data)
    emit('new_log', log_data, broadcast=True)

if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=5000)
