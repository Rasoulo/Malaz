<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('bookings', function (Blueprint $table) {
            $table->id();

            // Foreign keys
            $table->foreignId('user_id')->constrained()->cascadeOnDelete()->cascadeOnUpdate();
            $table->foreignId('property_id')->constrained()->cascadeOnDelete()->cascadeOnUpdate();

            // Booking details
            $table->date('check_in');
            $table->date('check_out');
            $table->enum('status', ['pending', 'confirmed', 'cancelled', 'rejected', 'completed', 'conflicted', 'ongoing'])->default('pending');

            // Payment details
            $table->decimal('total_price', 10, 2);

            $table->timestamps();
        });
    }


    public function down()
    {
        Schema::dropIfExists('bookings');
    }
};