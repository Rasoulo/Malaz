<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('properties', function (Blueprint $table) {
            $table->id();
            $table->foreignId('owner_id')->constrained('users')->references('id');
            $table->integer('price')->default(0);
            $table->string('governorate');
            $table->string('city');
            $table->string('address');
            $table->string('description')->nullable();
            $table->string('laititude')->nullable();
            $table->string('longitude')->nullable();
            $table->string('type')->default('flat');
            $table->integer('number_of_rooms')->default(0);
            $table->integer('number_of_baths')->default(0);
            $table->integer('area')->default(0);
            $table->integer('rating')->default(0);
            $table->integer('number_of_reviews')->default(0);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('properties');
    }
};
