using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpensesAppLibrary.Models
{
    public class BankBalanceModel
    {
        public int Id { get; set; }
        public int CostAccountID { get; set; }
        public string AccountName { get; set; }
        public string Bank { get; set; }
        public decimal Balance { get; set; }
        public decimal AvailableBalance { get; set; }
        public decimal Limit { get; set; }
        public string Account { get; set; }
    }
}
