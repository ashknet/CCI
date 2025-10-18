using Microsoft.EntityFrameworkCore;
using MessagingService.Core.Entities;
using Thread = MessagingService.Core.Entities.Thread;

namespace MessagingService.Infrastructure.Data;

public class MessagingDbContext : DbContext
{
    public MessagingDbContext(DbContextOptions<MessagingDbContext> options) : base(options) { }

    public DbSet<Thread> Threads => Set<Thread>();
    public DbSet<Message> Messages => Set<Message>();
    public DbSet<MessageAttachment> MessageAttachments => Set<MessageAttachment>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema("Messaging");
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Thread>(entity =>
        {
            entity.ToTable("Threads", "Messaging");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.CreatedAt);
            entity.HasIndex(e => e.LastMessageAt);
        });

        modelBuilder.Entity<Message>(entity =>
        {
            entity.ToTable("Messages", "Messaging");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.ThreadId);
            entity.HasOne(e => e.Thread)
                .WithMany(t => t.Messages)
                .HasForeignKey(e => e.ThreadId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        modelBuilder.Entity<MessageAttachment>(entity =>
        {
            entity.ToTable("MessageAttachments", "Messaging");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.MessageId);
            entity.HasOne(e => e.Message)
                .WithMany(m => m.Attachments)
                .HasForeignKey(e => e.MessageId)
                .OnDelete(DeleteBehavior.Cascade);
        });
    }
}
