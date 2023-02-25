using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpensesAppLibrary.Models
{
    public class TaxRateModel
    {
        public int Id { get; set; }
        public decimal Annual { get; set; }
        public decimal TaxThreshold { get; set; }
        public decimal Base { get; set; }
        public decimal TaxPercent { get; set; }
        public decimal MedicareLevy { get; set; }
        public decimal HELLP { get; set; }
    }
}
