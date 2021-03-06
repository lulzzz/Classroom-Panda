﻿using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

namespace DayCare.API.Migrations
{
    public partial class StudentActivityDiaperTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "StudentActivityDiaper",
                columns: table => new
                {
                    IsActive = table.Column<bool>(nullable: false),
                    IsDeleted = table.Column<bool>(nullable: false),
                    DeletedBy = table.Column<long>(nullable: true),
                    DeletedDate = table.Column<DateTime>(nullable: true),
                    DeletedFromIP = table.Column<string>(nullable: true),
                    CreatedBy = table.Column<long>(nullable: true),
                    CreatedDate = table.Column<DateTime>(nullable: true),
                    CreatedFromIP = table.Column<string>(nullable: true),
                    UpdatedDate = table.Column<DateTime>(nullable: true),
                    UpdatedFromIP = table.Column<string>(nullable: true),
                    UpdatedBy = table.Column<long>(nullable: true),
                    StudentActivityDiaperID = table.Column<long>(nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.SerialColumn),
                    AgencyID = table.Column<long>(nullable: false),
                    StudentActivitiesID = table.Column<long>(nullable: false),
                    StudentActivityDiaperNote = table.Column<string>(maxLength: 1000, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StudentActivityDiaper", x => x.StudentActivityDiaperID);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "StudentActivityDiaper");
        }
    }
}
