<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Malaz</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* Custom color palette - a rich, smooth brownish-gold */
        :root {
            --primary: #B8860B; /* Dark Goldenrod - between gold and brown */
            --primary-light: #DAA520; /* Goldenrod */
            --primary-dark: #8B6914; /* Darker shade */
            --accent: #A0522D; /* Sienna brown */
            --text-dark: #1a202c;
            --text-light: #718096;
            --bg-light: #f8f9fa;
        }

        body {
            background-color: var(--bg-light);
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
        }

        .brand-gradient {
            background: linear-gradient(135deg, var(--primary) 0%, var(--accent) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .btn-primary {
            background-color: var(--primary);
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
            transform: translateY(-1px);
            box-shadow: 0 10px 20px rgba(184, 134, 11, 0.2);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        .focus-primary:focus {
            border-color: var(--primary-light);
            box-shadow: 0 0 0 3px rgba(184, 134, 11, 0.1);
        }

        .input-focus:focus {
            border-color: var(--primary);
        }

        .dot {
            color: var(--primary);
        }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center p-4 bg-gradient-to-br from-amber-50 to-gray-50">
<div class="bg-white rounded-2xl shadow-xl w-full max-w-md overflow-hidden border border-gray-100">
    <!-- Decorative top bar -->
    <div class="h-2 w-full" style="background: linear-gradient(90deg, var(--primary), var(--accent))"></div>

    <div class="p-8">
        <!-- Header -->
        <div class="text-center mb-10">
            <h1 class="text-4xl font-bold text-gray-900 mb-2">
                Malaz<span class="dot">.</span>
            </h1>
            <p class="text-gray-600 font-medium">Admin Dashboard</p>
            <div class="mt-4">
                <div class="inline-block h-1 w-16 rounded-full" style="background-color: var(--primary)"></div>
            </div>
        </div>

        <!-- Messages -->
        @if($errors->any())
            <div class="bg-red-50 border-l-4 border-red-500 text-red-700 p-4 rounded-lg mb-6">
                <div class="flex">
                    <div class="flex-shrink-0">
                        <i class="fas fa-exclamation-circle"></i>
                    </div>
                    <div class="ml-3">
                        @foreach($errors->all() as $error)
                            <p class="text-sm">{{ $error }}</p>
                        @endforeach
                    </div>
                </div>
            </div>
        @endif

        @if(session('status'))
            <div class="bg-green-50 border-l-4 border-green-500 text-green-700 p-4 rounded-lg mb-6">
                <div class="flex">
                    <div class="flex-shrink-0">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="ml-3">
                        <p class="text-sm">{{ session('status') }}</p>
                    </div>
                </div>
            </div>
        @endif

        <!-- Form -->
        <form method="POST" action="{{ route('admin.login.post') }}" class="space-y-6">
            @csrf

            <!-- Email -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    <i class="fas fa-envelope mr-2 text-gray-400"></i>Email Address
                </label>
                <div class="relative rounded-lg shadow-sm">
                    <input
                        type="email"
                        name="email"
                        value="{{ old('email') }}"
                        class="block w-full pl-12 pr-3 py-3 border border-gray-300 rounded-lg focus:outline-none input-focus focus-primary transition duration-150 ease-in-out"
                        placeholder="admin@malaz.com"
                        required
                        autofocus>
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <i class="fas fa-user text-gray-400"></i>
                    </div>
                </div>
            </div>

            <!-- Password -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    <i class="fas fa-lock mr-2 text-gray-400"></i>Password
                </label>
                <div class="relative rounded-lg shadow-sm">
                    <input
                        type="password"
                        name="password"
                        id="password"
                        class="block w-full pl-12 pr-12 py-3 border border-gray-300 rounded-lg focus:outline-none input-focus focus-primary transition duration-150 ease-in-out"
                        placeholder="••••••••"
                        required>
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <i class="fas fa-key text-gray-400"></i>
                    </div>
                    <button
                        type="button"
                        onclick="togglePassword()"
                        class="absolute inset-y-0 right-0 pr-3 flex items-center"
                        style="color: var(--primary)">
                        <i class="fas fa-eye" id="eyeIcon"></i>
                    </button>
                </div>
            </div>

            <!-- Remember Me -->
            <div class="flex items-center justify-between">
                <div class="flex items-center">
                    <input
                        type="checkbox"
                        id="remember"
                        name="remember"
                        class="h-4 w-4 rounded border-gray-300 focus:outline-none"
                        style="color: var(--primary)">
                    <label for="remember" class="ml-2 text-sm text-gray-700">Remember this device</label>
                </div>
            </div>

            <!-- Submit Button -->
            <button
                type="submit"
                class="w-full btn-primary text-white font-medium py-3 px-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-dark transition duration-150 ease-in-out">
                <i class="fas fa-sign-in-alt mr-2"></i>Sign In to Dashboard
            </button>
        </form>

        <!-- Security Note -->
        <div class="mt-8 p-4 bg-gray-50 rounded-lg border border-gray-200">
            <div class="flex items-start">
                <div class="flex-shrink-0">
                    <i class="fas fa-shield-alt" style="color: var(--primary)"></i>
                </div>
                <div class="ml-3">
                    <h3 class="text-sm font-medium text-gray-900">Secure Access</h3>
                    <p class="mt-1 text-xs text-gray-600">This portal is restricted to authorized Malaz administrators only.</p>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <div class="mt-10 pt-6 border-t border-gray-200 text-center">
            <p class="text-xs text-gray-500">
                © {{ date('Y') }} Malaz Property Rental. All rights reserved.<br>
                <span class="mt-1 inline-block">Admin Portal • Version 1.0</span>
            </p>
        </div>
    </div>
</div>

<script>
    function togglePassword() {
        const password = document.getElementById('password');
        const eyeIcon = document.getElementById('eyeIcon');

        if (password.type === 'password') {
            password.type = 'text';
            eyeIcon.classList.remove('fa-eye');
            eyeIcon.classList.add('fa-eye-slash');
        } else {
            password.type = 'password';
            eyeIcon.classList.remove('fa-eye-slash');
            eyeIcon.classList.add('fa-eye');
        }
    }

    // Add smooth focus effects
    document.addEventListener('DOMContentLoaded', function() {
        const inputs = document.querySelectorAll('input[type="email"], input[type="password"]');

        inputs.forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.classList.add('ring-2');
                this.parentElement.style.boxShadow = '0 0 0 3px rgba(184, 134, 11, 0.1)';
            });

            input.addEventListener('blur', function() {
                this.parentElement.classList.remove('ring-2');
                this.parentElement.style.boxShadow = '';
            });
        });

        // Add a subtle animation to the form
        const form = document.querySelector('form');
        form.style.opacity = '0';
        form.style.transform = 'translateY(20px)';

        setTimeout(() => {
            form.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            form.style.opacity = '1';
            form.style.transform = 'translateY(0)';
        }, 100);
    });
</script>
</body>
</html>
