<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Property>
 */
class PropertyFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    protected $model = \App\Models\Property::class;
    public function definition(): array
    {
        return [
            'owner_id' => User::factory(),
            'price' => $this->faker->numberBetween(50000, 500000),
            'governorate' => $this->faker->state,
            'city' => $this->faker->city,
            'address' => $this->faker->streetAddress,
            'description' => $this->faker->sentence(10),
            'laititude' => $this->faker->latitude(),
            'longitude' => $this->faker->longitude(),
            'type' => $this->faker->randomElement(['Apartment', 'Farm', 'Villa', 'Restaurant']),
            'number_of_rooms' => $this->faker->numberBetween(1, 10),
            'number_of_baths' => $this->faker->numberBetween(1, 5),
            'area' => $this->faker->numberBetween(50, 500),
            'rating' => $this->faker->numberBetween(50, 300),
            'number_of_reviews' => $this->faker->numberBetween(0, 100),
        ];
    }
}
