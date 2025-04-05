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
