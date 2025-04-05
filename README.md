<a id="readme-top"></a>
# HearWay
<p align="center">
  <img src="img/HearWay logo.jpg" width="150" hspace="20">
</p>

<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#project-description">Project Description</a>
    </li>
    <li>
      <a href="#how-it-worked">How it Worked</a>
    </li>
    <li>
      <a href="#objectives">Objectives</a>
    </li>
    <li>
      <a href="#technologies-used">Technologies Used</a>
    </li>
    <li>
      <a href="#setup-guide">Setup Guide</a>
    </li>
  </ol>
</details>

## Project Description
**HearWay** is an all-in-one **AI-powered mobile application** designed for **visually impaired individuals** to navigate public spaces safely with instant feedback. The application totally removes the need of human volunteers or extra equipment such as LiDAR through employing **Google Cloud AI services** for edge and obstacle detection.<br>
<br>Here's the function : <br>
 🗣️ It provides **real-time text-to-speech** assistance and detects **obstacles, platform edges and gaps** in real-time<br>
 ⚡ The application offers **instant feedback** through **vibration, voice alerts and AI text-to-speech** to warn users about potential hazards<br>
 🌐 It utilizes a **scalable backend architecture** for fast and efficient AI processing in navigational aids for users

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## How it Worked

### 1. **Start & Scan** 📱  
Launch the HearWay app and activate the system by clicking the **Start** button  
> The app uses the smartphone camera to constantly monitor the environment

### 2. **Obstacle Detection** 🚧  
The camera continuously scans the surroundings, detecting platform edges, gaps and obstacles

### 3. **Instant Feedback & Alerts** ⚠️  
When an obstacle or hazard is detected:  
- A **red frame** highlights the detected object on the screen  
- **Voice alerts and AI text-to-speech** generate and display a warning message *(e.g., "Watch out! There is a person in front of you")* to inform users of the hazard  
- **Vibration feedback** provides a secondary sensory alert  

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Objectives

### 1. **Accessibility 🧑‍🦯**
  * Fully accessible AI-powered mobile application for visually impaired individuals
  * No additional hardware required

### 2. **Navigation Assistance 📣**
  * Instant feedback through vibration, voice alerts and AI text-to-speech
  * Real-time warnings about potential hazards

### 3. **Efficiency and Scalability 🌐**
  * Scalable backend architecture for fast and efficient AI processing
  * Support thousands of users simultaneously without lag
  * Enhance detection accuracy over time by analyzing past obstacle data using Google Cloud AI

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Technologies Used
<p align="center">
  <a href="https://flutter.dev/">
    <img src="img/flutter logo.png" width="150" hspace="20" alt="Flutter">
  </a>
  <a href="https://www.djangoproject.com/">
    <img src="img/django logo.png" width="150" hspace="20" alt="Django">
  </a>
  <a href="https://www.sqlite.org/">
    <img src="img/sqlite logo.png" width="150" hspace="20" alt="SQLite">
  </a>
</p>

<p align="center">
  <a href="https://cloud.google.com/">
    <img src="img/GC.png" width="200" hspace="20" alt="Google Cloud">
  </a>
  <a href="https://cloud.google.com/vision">
    <img src="img/GC vision api.png" width="150" hspace="20" alt="Google Cloud Vision API">
  </a>
  <a href="https://cloud.google.com/text-to-speech">
    <img src="img/GC speech api.png" width="150" hspace="20" alt="Google Cloud Text-to-Speech API">
  </a>
</p>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Setup Guide
 
 ### 1. Clone the Repository
 
 ```bash
 git clone https://github.com/zhengyu89/Blind_Edge_Detection_Project.git
 cd Blind_Edge_Detection_Project
 ```
 ## 🐍 Backend Setup (Django + Google Cloud Vision)
 
 ### 2. Create & Activate Virtual Environment
 
 ```bash
 python -m venv venv
 
 # Activate on Windows
 venv\Scripts\activate
 
 # Activate on macOS/Linux
 source venv/bin/activate
 ```
 
 ### 3. Install Required Dependencies
 
 ```bash
 pip install -r requirements.txt
 ```
 
 ### 4. Configure Google Cloud Credentials
 
 #### a. Create a .env file and set your credential path:
 
 ```env
 GOOGLE_APPLICATION_CREDENTIALS=C:\YourPath\Blind_Edge_Detection_Project\backend\config\service-account.json
 ```
 
 #### b. Create a folder for your credentials:
 
 ```bash
 mkdir backend/config
 ```
 
 #### c. Place your Google Cloud Service Account Key in `backend/config/` and name it:
 
 ```
 service-account.json
 ```
 
 ## 📱 Android Device Setup (for Flutter Testing)
 
 > Note: A physical Android device is required for real-time image capture and testing.
 
 ### 5. Enable USB Debugging
 
 * Open Settings > About Phone
 * Tap Build Number 7 times to enable Developer Options
 * Go to Developer Options and enable USB Debugging
 
 ### 6. Connect Phone via ADB (Command Prompt Only)
 
 #### In Command Prompt (cmd), run:
 
 ```bash
 adb devices
 adb reverse tcp:8000 tcp:8000
 ```
 
 >This allows your Android device to connect to the backend server running on your computer.
 
 ### 7. Select Device in VS Code
 
 * In VS Code, choose your phone from the Flutter device dropdown (bottom-right corner)
 
 ## 🚀 Running the App
 
 ### 8. Start Django Backend Server
 
 ```bash
 # Activate virtual environment (if not already)
 venv\Scripts\activate  # Windows
 source venv/bin/activate  # macOS/Linux
 
 # Navigate to backend
 cd backend
 
 # Run the server
 python manage.py runserver
 ```
 
 ### 9. Run Flutter Frontend
 
 #### Open a new terminal:
 
 ```bash
 cd frontend
 flutter run
 ```
 
 ## 📌 Notes
 * Make sure your phone and computer are on the same network if you're using ADB over TCP/IP.
 * Use flutter doctor to ensure your dev environment is properly set up.
 * Use `flutter doctor` to ensure your dev environment is properly set up.
 
 ## 💪 You're good to go!
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 <p align="right">(<a href="#readme-top">back to top</a>)</p>
