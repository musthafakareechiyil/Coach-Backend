# Backend

This is the backend API for the Survey System, built with Ruby on Rails and PostgreSQL. It supports dynamic survey creation, user participation, and KPI-based analysis.

## 🔧 Tech Stack

- **Ruby**: 3.2.4  
- **Rails**: 8.0.2
- **Database**: PostgreSQL  
- **Authentication**: Dummy login (Devise JWT planned)  

## 🚀 Setup & Installation

### Prerequisites

- Ruby 3.2.4
- PostgreSQL installed and running
- Bundler

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/musthafakareechiyil/Coach-Backend.git
   cd Coach-Backend
   
2. Install dependencies:
   ```bash
   bundle install
   
3. Set up the database:
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed

4. Start the server:
   ```bash
   rails s

📘 API Documentation
   Full API documentation is available via Postman:
   https://documenter.getpostman.com/view/28032008/2sB2cX91kz

📌 Notes
- Authentication is handled using a dummy login system.
- Seeds are available for testing the survey flow.



