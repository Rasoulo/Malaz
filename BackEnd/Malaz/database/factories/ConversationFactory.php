<?php

namespace Database\Factories;

use App\Models\User;
use App\Models\Message;
use App\Models\Conversation;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Conversation>
 */
class ConversationFactory extends Factory
{
    protected $model = \App\Models\Conversation::class;

    public function definition(): array
    {
        return [
            'user_one_id' => User::factory(),
            'user_two_id' => User::factory(),
        ];
    }

    public function configure()
    {
        return $this->afterCreating(function (Conversation $conversation) {
            Message::factory()->count(50)->create([
                'conversation_id' => $conversation->id,
                'sender_id' => $this->faker->randomElement([
                    $conversation->user_one_id,
                    $conversation->user_two_id,
                ]),
            ]);
        });
    }

}
