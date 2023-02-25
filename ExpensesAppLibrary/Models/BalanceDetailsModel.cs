using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpensesAppLibrary.Models
{
    public class BalanceDetailsModel
    {
        public int Id { get; set; }
        public string Description { get; set; }
        public int BalanceGroupId { get; set; }
        public int RecurringId { get; set; }
        public int DebitAccount { get; set; }
        public int CreditAccount { get; set; }
        public bool Status { get; set; }
    }
}
