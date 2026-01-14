<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Support\Str;
use Illuminate\Database\Seeder;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // User::updateOrCreate(
        //     ['phone' => '0999999999'],
        //     [
        //         'first_name' => 'Super',
        //         'last_name' => 'Admin',
        //         'role' => 'ADMIN',
        //         'date_of_birth' => '1990-01-01',
        //         'profile_image' => 'default_admin_profile.png',
        //         'identity_card_image' => 'default_admin_id.png',
        //         'phone_verified_at' => now(),
        //         'password' => bcrypt('Admin@123'),
        //         'remember_token' => Str::random(10),
        //     ]
        // );
        $base64Image1 = [];
        $base64Image2 = [];

        for ($i = 1; $i <= 4; $i++) {
            $path = database_path('seeders/images/persons/' . $i . '.png');
            $base64Image1[] = base64_encode(file_get_contents($path));

            $path = database_path('seeders/images/identity_cards/' . $i . '.png');
            $base64Image2[] = base64_encode(file_get_contents($path));
        }


        User::updateOrCreate(
            ['phone' => '20200124'],
            [
                'first_name' => 'Anya',
                'last_name' => 'Petrrva',
                'role' => 'USER',
                'date_of_birth' => '2002-05-22',
                'profile_image' => $base64Image1[0],
                'identity_card_image' => $base64Image2[0],
                'profile_image_mime' => 'image/png',
                'identity_card_mime' => 'image/png',
                'phone_verified_at' => now(),
                'password' => bcrypt('password'),
                'remember_token' => Str::random(10),
            ]
        );

        User::updateOrCreate(
            ['phone' => '22300465'],
            [
                'first_name' => 'Kwame',
                'last_name' => 'Adebyo',
                'role' => 'USER',
                'date_of_birth' => '1998-05-26',
                'profile_image' => $base64Image1[1],
                'identity_card_image' => $base64Image2[1],
                'profile_image_mime' => 'image/png',
                'identity_card_mime' => 'image/png',
                'phone_verified_at' => now(),
                'password' => bcrypt('password'),
                'remember_token' => Str::random(10),
            ]
        );

        User::updateOrCreate(
            ['phone' => '203310439'],
            [
                'first_name' => 'Priya',
                'last_name' => 'Sharna',
                'role' => 'USER',
                'date_of_birth' => '1999-10-10',
                'profile_image' => $base64Image1[2],
                'identity_card_image' => $base64Image2[2],
                'profile_image_mime' => 'image/png',
                'identity_card_mime' => 'image/png',
                'phone_verified_at' => now(),
                'password' => bcrypt('password'),
                'remember_token' => Str::random(10),
            ]
        );

        User::updateOrCreate(
            ['phone' => '20300111'],
            [
                'first_name' => 'Lukas',
                'last_name' => 'Jensen',
                'role' => 'USER',
                'date_of_birth' => '1995-7-19',
                'profile_image' => $base64Image1[3],
                'identity_card_image' => $base64Image2[3],
                'profile_image_mime' => 'image/png',
                'identity_card_mime' => 'image/png',
                'phone_verified_at' => now(),
                'password' => bcrypt('password'),
                'remember_token' => Str::random(10),
            ]
        );
    }
}
