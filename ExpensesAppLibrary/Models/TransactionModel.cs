using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpensesAppLibrary.Models
{
    public class TransactionModel
    {
        public int Id { get; set; }
        public int RecurranceID { get; set; }
        public DateTime DatePaid { get; set; }
        public bool Confirmed { get; set; }
        public string Description { get; set; }
        public int DebitID { get; set; }
        public int CreditID { get; set; }
        public decimal Amount { get; set; }
    }
}

