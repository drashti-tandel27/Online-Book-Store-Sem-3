<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <title>Admin Login - Online Book Store</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: Arial, sans-serif;
            background: #f5f7fb;
        }

        .login-card {
            width: 100%;
            max-width: 430px;
            background: white;
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.08);
        }

        .logo {
            text-align: center;
            font-size: 42px;
            margin-bottom: 10px;
        }

        h1 {
            text-align: center;
            margin: 0;
            font-size: 26px;
        }

        .subtitle {
            text-align: center;
            color: #6b7280;
            margin-bottom: 28px;
        }

        label {
            display: block;
            margin-bottom: 7px;
            font-weight: 600;
        }

        input {
            width: 100%;
            padding: 13px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 15px;
            margin-bottom: 18px;
            outline: none;
        }

        input:focus {
            border-color: #2563eb;
        }

        .login-btn {
            width: 100%;
            padding: 13px;
            border: none;
            border-radius: 8px;
            background: #2563eb;
            color: white;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
        }

        .login-btn:hover {
            background: #1d4ed8;
        }

        .alert {
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .error {
            background: #fee2e2;
            color: #b91c1c;
        }

        .success {
            background: #dcfce7;
            color: #166534;
        }

        .footer {
            text-align: center;
            margin-top: 20px;
            color: #9ca3af;
            font-size: 13px;
        }

    </style>

</head>

<body>

<div class="login-card">

    <div class="logo">
        📖
    </div>

    <h1>
        Admin Login
    </h1>

    <p class="subtitle">
        Online Book Store Administration
    </p>


    @if(session('error'))

        <div class="alert error">
            {{ session('error') }}
        </div>

    @endif


    @if(session('success'))

        <div class="alert success">
            {{ session('success') }}
        </div>

    @endif


    @if($errors->any())

        <div class="alert error">

            @foreach($errors->all() as $error)

                <div>{{ $error }}</div>

            @endforeach

        </div>

    @endif


    <form
        method="POST"
        action="{{ route('admin.login.submit') }}"
    >

        @csrf

        <label>
            Email
        </label>

        <input
            type="email"
            name="email"
            value="{{ old('email') }}"
            placeholder="Enter admin email"
            required
            autofocus
        >


        <label>
            Password
        </label>

        <input
            type="password"
            name="password"
            placeholder="Enter password"
            required
        >


        <button
            type="submit"
            class="login-btn"
        >
            🔐 Login
        </button>

    </form>


    <div class="footer">
        Online Book Store Admin Panel
    </div>

</div>

</body>

</html>