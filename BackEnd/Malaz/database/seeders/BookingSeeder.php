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
        for ($i = 0; $i < 10; $i++) {
            $checkIn = Carbon::now()->subDays(rand(10, 100));
            $checkOut = (clone $checkIn)->addDays(rand(1, 5));

            Booking::create([
                'user_id' => 2,
                'property_id' => 1,
                'check_in' => $checkIn,
                'check_out' => $checkOut,
                'status' => 'completed',
                'total_price' => rand(100, 1000),
            ]);
        }

        for ($i = 0; $i < 10; $i++) {
            $checkIn = Carbon::now()->subDays(rand(10, 100));
            $checkOut = (clone $checkIn)->addDays(rand(1, 5));

            Booking::create([
                'user_id' => 2,
                'property_id' => 1,
                'check_in' => $checkIn,
                'check_out' => $checkOut,
                'status' => 'confirmed',
                'total_price' => rand(100, 1000),
            ]);
        }
    }
}
