﻿using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace DayCare.API.Migrations
{
    public partial class AddedColumnMedicationDoneDate : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "MedicationDoneDate",
                table: "StudentActivityMedication",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "MedicationDoneDate",
                table: "StudentActivityMedication");
        }
    }
}
