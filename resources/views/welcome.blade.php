<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome Page</title>

    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, Helvetica, sans-serif;
            background: #f4f6f9;
            color: #333;
        }

        header {
            background: #4a90e2;
            padding: 20px;
            text-align: center;
            color: white;
        }

        h1 {
            margin: 0;
            font-size: 32px;
        }

        .container {
            max-width: 900px;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .container h2 {
            color: #4a90e2;
        }

        .btn {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 22px;
            background: #4a90e2;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-size: 16px;
        }

        .btn:hover {
            background: #3a7acb;
        }

        footer {
            text-align: center;
            padding: 15px;
            margin-top: 40px;
            font-size: 14px;
            background: #eee;
        }
    </style>
</head>
<body>

    <header>
        <h1>Welcome to My Webpage</h1>
        <p>Your clean, modern, and simple HTML layout</p>
    </header>

    <div class="container">
        <h2>About This Page</h2>
        <p>
            This webpage is designed with a clean layout, soft colors, and simple structure.  
            You can freely modify it and add your own sections like services, contact details, or forms.
        </p>

        <h2>Features</h2>
        <ul>
            <li>Fully responsive layout</li>
            <li>Modern card-style container</li>
            <li>Elegant header and footer</li>
            <li>No external libraries required</li>
        </ul>

        <a href="#" class="btn">Learn More</a>
    </div>

    <footer>
        © 2025 Your Website. All rights reserved.
    </footer>

</body>
</html>
