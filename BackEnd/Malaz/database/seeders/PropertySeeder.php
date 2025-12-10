<?php

namespace Database\Seeders;

use App\Models\Property;
use Database\Factories\PropertyFactory;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class PropertySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Property::factory()->count(50)->create();   
    }
}
