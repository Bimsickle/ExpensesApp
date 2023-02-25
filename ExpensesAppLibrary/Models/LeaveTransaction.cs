using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpensesAppLibrary.Models
{
    public class LeaveTransaction
    {
        public int Id { get; set; }
        public int LeaveId { get; set; }
        public DateTime Date { get; set; }
        public decimal HoursDebit { get; set; }
        public decimal HoursCredit { get; set; }
    }
}
