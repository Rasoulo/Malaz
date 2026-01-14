<?php

namespace Database\Seeders;

use Carbon\Carbon;
use App\Models\Booking;
use Illuminate\Database\Seeder;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class BookingSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        for ($i = 2; $i < 6; $i++) {
            $checkIn = Carbon::now()->subDays(rand(1, 10));
            $checkOut = (clone $checkIn)->addDays(rand(15, 25));

            Booking::create([
                'user_id' => $i,
                'property_id' => rand(70, 75),
                'check_in' => $checkIn,
                'check_out' => $checkOut,
                'status' => 'ongoing',
                'total_price' => rand(100, 1000),
            ]);
        }

        for ($i = 2; $i < 6; $i++) {
            $checkIn = Carbon::now()->subDays(rand(10, 100));
            $checkOut = (clone $checkIn)->addDays(rand(1, 5));

            Booking::create([
                'user_id' => $i,
                'property_id' => rand(70, 75),
                'check_in' => $checkIn,
                'check_out' => $checkOut,
                'status' => 'pending',
                'total_price' => rand(100, 1000),
            ]);
        }

        for ($i = 2; $i < 6; $i++) {
            $checkIn = Carbon::now()->subDays(rand(10, 100));
            $checkOut = (clone $checkIn)->addDays(rand(1, 5));

            Booking::create([
                'user_id' => $i,
                'property_id' => rand(70, 75),
                'check_in' => $checkIn,
                'check_out' => $checkOut,
                'status' => 'confirmed',
                'total_price' => rand(100, 1000),
            ]);
        }

        for ($i = 2; $i < 6; $i++) {
            $checkIn = Carbon::now()->subDays(rand(10, 100));
            $checkOut = (clone $checkIn)->addDays(rand(1, 5));

            Booking::create([
                'user_id' => $i,
                'property_id' => rand(70, 75),
                'check_in' => $checkIn,
                'check_out' => $checkOut,
                'status' => 'cancelled',
                'total_price' => rand(100, 1000),
            ]);
        }

        for ($i = 2; $i < 6; $i++) {
            $checkIn = Carbon::now()->subDays(rand(10, 100));
            $checkOut = (clone $checkIn)->addDays(rand(1, 5));

            Booking::create([
                'user_id' => $i,
                'property_id' => rand(70, 75),
                'check_in' => $checkIn,
                'check_out' => $checkOut,
                'status' => 'rejected',
                'total_price' => rand(100, 1000),
            ]);
        }

        for ($i = 2; $i < 6; $i++) {
            $checkIn = Carbon::now()->subDays(rand(10, 100));
            $checkOut = (clone $checkIn)->addDays(rand(1, 5));

            Booking::create([
                'user_id' => $i,
                'property_id' => rand(70, 75),
                'check_in' => $checkIn,
                'check_out' => $checkOut,
                'status' => 'completed',
                'total_price' => rand(100, 1000),
            ]);
        }

        for ($i = 2; $i < 6; $i++) {
            $checkIn = Carbon::now()->subDays(rand(10, 100));
            $checkOut = (clone $checkIn)->addDays(rand(1, 5));

            Booking::create([
                'user_id' => $i,
                'property_id' => rand(70, 75),
                'check_in' => $checkIn,
                'check_out' => $checkOut,
                'status' => 'conflicted',
                'total_price' => rand(100, 1000),
            ]);
        }

    }
}