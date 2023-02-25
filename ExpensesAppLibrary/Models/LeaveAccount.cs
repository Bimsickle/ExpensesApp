namespace ExpensesAppLibrary.Models
{
    public class LeaveAccount
    {
        public int Id { get; set; }
        public string Type { get; set; }
        public bool Status { get; set; }
        public bool Paid { get; set; }
        public DateTime StartDate { get; set; }
        public bool PayableOnExit { get; set; }
        public decimal TotalEarned { get; set; }
        public int TotalType { get; set; }
        public decimal AccrualPeriod { get; set; }
        public int AccrualType { get; set; }
        public decimal HourRate { get; set; }
    }
}
