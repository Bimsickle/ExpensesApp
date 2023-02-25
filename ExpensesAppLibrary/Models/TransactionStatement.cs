using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpensesAppLibrary.Models
{
    public class TransactionStatement
    {
        public int Id { get; set; }
        public string Recurring { get; set; }
        public DateTime DatePaid { get; set; }
        public bool Confirmed { get; set; }
        public string Description { get; set; }
        public string AccountFrom { get; set; }
        public string AccountTo { get; set; }
        public decimal MoneyOut { get; set; }
        public decimal MoneyIn { get; set; }
        public int Highlight { get; set; }

    }
}
