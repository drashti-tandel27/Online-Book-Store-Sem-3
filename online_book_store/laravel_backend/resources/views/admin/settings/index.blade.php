<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <title>Settings - Admin</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f5f7fb;
            color: #1f2937;
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 30px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        h1 {
            margin: 0 0 6px;
            font-size: 28px;
        }

        .header p {
            margin: 0;
            color: #6b7280;
        }

        .back-btn {
            padding: 11px 18px;
            background: #6b7280;
            color: white;
            text-decoration: none;
            border-radius: 8px;
        }

        .card {
            background: white;
            padding: 30px;
            border-radius: 14px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            margin-bottom: 20px;
        }

        .card h2 {
            margin-top: 0;
            margin-bottom: 22px;
            font-size: 20px;
        }

        .grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .field {
            margin-bottom: 5px;
        }

        .full {
            grid-column: 1 / -1;
        }

        label {
            display: block;
            margin-bottom: 7px;
            font-weight: 600;
        }

        input,
        textarea,
        select {
            width: 100%;
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 15px;
            outline: none;
        }

        input:focus,
        textarea:focus,
        select:focus {
            border-color: #2563eb;
        }

        textarea {
            min-height: 110px;
            resize: vertical;
        }

        .error {
            color: #dc2626;
            font-size: 13px;
            margin-top: 5px;
        }

        .success {
            background: #dcfce7;
            color: #166534;
            padding: 13px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .save-btn {
            margin-top: 25px;
            padding: 12px 24px;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            cursor: pointer;
        }

        .save-btn:hover {
            background: #1d4ed8;
        }

        .info-box {
            background: #f8fafc;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            padding: 18px;
        }

        .info-box p {
            margin: 7px 0;
            color: #6b7280;
        }

        @media (max-width: 700px) {

            .container {
                padding: 20px;
            }

            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .grid {
                grid-template-columns: 1fr;
            }

            .full {
                grid-column: auto;
            }

        }

    </style>

</head>

<body>

<div class="container">

    <div class="header">

        <div>
            <h1>⚙️ Settings</h1>
            <p>Manage your online book store settings.</p>
        </div>

        <a
            href="{{ route('admin.dashboard') }}"
            class="back-btn"
        >
            ← Back to Dashboard
        </a>

    </div>


    @if(session('success'))

        <div class="success">
            ✓ {{ session('success') }}
        </div>

    @endif


    <form
        method="POST"
        action="{{ route('admin.settings.update') }}"
    >

        @csrf
        @method('PUT')


        <!-- Store Settings -->

        <div class="card">

            <h2>🏪 Store Settings</h2>

            <div class="grid">

                <div class="field">

                    <label>
                        Store Name
                    </label>

                    <input
                        type="text"
                        name="store_name"
                        value="{{ old('store_name', 'Online Book Store') }}"
                        required
                    >

                    @error('store_name')
                        <div class="error">{{ $message }}</div>
                    @enderror

                </div>


                <div class="field">

                    <label>
                        Currency
                    </label>

                    <select name="currency" required>

                        <option
                            value="INR"
                            {{ old('currency', 'INR') == 'INR' ? 'selected' : '' }}
                        >
                            INR (₹)
                        </option>

                        <option
                            value="USD"
                            {{ old('currency') == 'USD' ? 'selected' : '' }}
                        >
                            USD ($)
                        </option>

                        <option
                            value="EUR"
                            {{ old('currency') == 'EUR' ? 'selected' : '' }}
                        >
                            EUR (€)
                        </option>

                    </select>

                    @error('currency')
                        <div class="error">{{ $message }}</div>
                    @enderror

                </div>


                <div class="field full">

                    <label>
                        Store Address
                    </label>

                    <textarea
                        name="store_address"
                        placeholder="Enter store address"
                    >{{ old('store_address') }}</textarea>

                    @error('store_address')
                        <div class="error">{{ $message }}</div>
                    @enderror

                </div>


                <div class="field">

                    <label>
                        Contact Number
                    </label>

                    <input
                        type="text"
                        name="contact_number"
                        value="{{ old('contact_number') }}"
                        placeholder="+91 XXXXX XXXXX"
                    >

                    @error('contact_number')
                        <div class="error">{{ $message }}</div>
                    @enderror

                </div>

            </div>

        </div>


        <!-- Admin Profile -->

        <div class="card">

            <h2>👤 Admin Profile</h2>

            <div class="grid">

                <div class="field">

                    <label>
                        Admin Name
                    </label>

                    <input
                        type="text"
                        name="admin_name"
                        value="{{ old('admin_name', 'Admin') }}"
                        required
                    >

                    @error('admin_name')
                        <div class="error">{{ $message }}</div>
                    @enderror

                </div>


                <div class="field">

                    <label>
                        Admin Email
                    </label>

                    <input
                        type="email"
                        name="admin_email"
                        value="{{ old('admin_email', 'admin@example.com') }}"
                        required
                    >

                    @error('admin_email')
                        <div class="error">{{ $message }}</div>
                    @enderror

                </div>

            </div>


            <button
                type="submit"
                class="save-btn"
            >
                💾 Save Settings
            </button>

        </div>


        <!-- System Information -->

        <div class="card">

            <h2>ℹ️ System Information</h2>

            <div class="info-box">

                <p>
                    <strong>Application:</strong>
                    Online Book Store
                </p>

                <p>
                    <strong>Backend:</strong>
                    Laravel
                </p>

                <p>
                    <strong>Database:</strong>
                    MySQL
                </p>

                <p>
                    <strong>Currency:</strong>
                    Indian Rupee (₹)
                </p>

            </div>

        </div>

    </form>

</div>

</body>
</html>