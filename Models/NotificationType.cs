﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace kontacto_api.Models
{
    [Table("NOTIFICATION_TYPE")]
    [Index(nameof(Type), Name = "UQ__NOTIFICA__80334AA158F6C826", IsUnique = true)]
    [Index(nameof(Message), Name = "UQ__NOTIFICA__819F327BB94DE2E7", IsUnique = true)]
    public partial class NotificationType
    {
        public NotificationType()
        {
            Notifications = new HashSet<Notification>();
        }

        [Key]
        [Column("ID")]
        [StringLength(36)]
        public string Id { get; set; }
        [Required]
        [Column("TYPE")]
        [StringLength(25)]
        public string Type { get; set; }
        [Required]
        [Column("MESSAGE")]
        [StringLength(50)]
        public string Message { get; set; }

        [InverseProperty(nameof(Notification.NotificationType))]
        public virtual ICollection<Notification> Notifications { get; set; }
    }
}