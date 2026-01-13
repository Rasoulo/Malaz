<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Review>
 */
class ReviewFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            // $table->foreignId('user_id')->constrained('users')->references('id')->cascadeOnDelete()->cascadeOnUpdate();
            // $table->foreignId('property_id')->constrained('properties')->references('id')->cascadeOnDelete()->cascadeOnUpdate();
            // $table->integer('rating')->nullable();
            // $table->string('body')->nullable();
            'user_id' => $this->faker->numberBetween(2, 5),
            'property_id' => $this->faker->numberBetween(73, 75),
            'rating' => $this->faker->numberBetween(1, 5),
            'body' => $this->faker->sentence(10),
        ];
    }
}
