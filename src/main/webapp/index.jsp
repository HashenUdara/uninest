<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Uninest</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/style.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
        }

        .landing-container {
            max-width: 1200px;
            padding: 2rem;
            text-align: center;
        }

        .logo {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .logo-icon {
            width: 60px;
            height: 60px;
            background: #fff;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            font-weight: bold;
            color: #667eea;
        }

        .logo h1 {
            font-size: 3rem;
            font-weight: 700;
            color: #fff;
        }

        .tagline {
            font-size: 1.5rem;
            margin-bottom: 3rem;
            opacity: 0.95;
            font-weight: 300;
        }

        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin: 3rem 0;
        }

        .feature-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            padding: 2rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: transform 0.3s ease, background 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            background: rgba(255, 255, 255, 0.15);
        }

        .feature-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        .feature-card h3 {
            font-size: 1.25rem;
            margin-bottom: 0.5rem;
        }

        .feature-card p {
            opacity: 0.9;
            line-height: 1.6;
        }

        .cta-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 3rem;
        }

        .btn {
            padding: 1rem 2rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            display: inline-block;
        }

        .btn-primary {
            background: #fff;
            color: #667eea;
        }

        .btn-primary:hover {
            transform: scale(1.05);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.2);
            color: #fff;
            border: 2px solid #fff;
        }

        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: scale(1.05);
        }

        @media (max-width: 768px) {
            .logo h1 {
                font-size: 2rem;
            }

            .tagline {
                font-size: 1.2rem;
            }

            .features {
                grid-template-columns: 1fr;
            }

            .cta-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="landing-container">
        <div class="logo">
            <div class="logo-icon">🎓</div>
            <h1>Uninest</h1>
        </div>

        <p class="tagline">Your Academic Community Platform</p>

        <div class="features">
            <div class="feature-card">
                <div class="feature-icon">📚</div>
                <h3>Resource Library</h3>
                <p>Access and share educational resources with your community</p>
            </div>

            <div class="feature-card">
                <div class="feature-icon">💬</div>
                <h3>Community Forums</h3>
                <p>Connect with peers, ask questions, and collaborate</p>
            </div>

            <div class="feature-card">
                <div class="feature-icon">📊</div>
                <h3>Track Progress</h3>
                <p>Monitor your learning journey and achievements</p>
            </div>

            <div class="feature-card">
                <div class="feature-icon">👥</div>
                <h3>Study Groups</h3>
                <p>Join or create study groups for better collaboration</p>
            </div>
        </div>

        <div class="cta-buttons">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Login</a>
            <a href="${pageContext.request.contextPath}/signup" class="btn btn-secondary">Sign Up</a>
        </div>
    </div>
</body>
</html>
