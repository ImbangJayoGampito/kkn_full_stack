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
        Schema::create("employee_roles", function (Blueprint $table) {
            $table->id();
            $table->string("name");
            $table->string("description");
            $table->string("permissions");
            $table->unsignedBigInteger("business");
            $table
                ->foreign("business")
                ->references("id")
                ->on("businesses")
                ->onDelete("cascade");
            $table->unsignedBigInteger("created_by");
            $table
                ->foreign("created_by")
                ->references("id")
                ->on("users")
                ->onDelete("cascade");
            $table->unsignedBigInteger("updated_by");
            $table
                ->foreign("updated_by")
                ->references("id")
                ->on("users")
                ->onDelete("cascade");
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists("employee_roles");
    }
};
