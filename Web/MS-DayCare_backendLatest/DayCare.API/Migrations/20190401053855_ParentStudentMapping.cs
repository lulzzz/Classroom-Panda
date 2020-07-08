﻿using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

namespace DayCare.API.Migrations
{
    public partial class ParentStudentMapping : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "MappingParentStudent",
                columns: table => new
                {
                    MappingID = table.Column<long>(nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.SerialColumn),
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
                    AgencyID = table.Column<long>(nullable: false),
                    ParentID = table.Column<long>(nullable: false),
                    StudentID = table.Column<long>(nullable: false),
                    IsParent = table.Column<bool>(nullable: false),
                    IsGaurdian = table.Column<bool>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MappingParentStudent", x => x.MappingID);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "MappingParentStudent");
        }
    }
}