using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.Windows.Threading;

namespace PizzaApp
{
    /// <summary>
    /// Логика взаимодействия для DisplayWindow.xaml
    /// </summary>
    public partial class DisplayWindow : Window //Табло
    {
        PizzaTestEntities _entities = new PizzaTestEntities();
        public ObservableCollection<InProcessOrders> InProcess { get; set; } = new ObservableCollection<InProcessOrders>();

        public ObservableCollection<ReadyOrders> Ready { get; set; } = new ObservableCollection<ReadyOrders>();
        private DispatcherTimer _timer;
        public DisplayWindow()
        {
            InitializeComponent();
            DataContext = this;
            LoadData();
            _timer = new DispatcherTimer
            {
                Interval = TimeSpan.FromSeconds(5)
            };
            _timer.Tick += (s, e) => LoadData();
            _timer.Start();
        }


        public void LoadData() //Выборка товаров только со статусами 2 - Готовится и 3 - Готов к выдаче. Распределение имен в корректный СтакПанел  
        {
            InProcess.Clear();
            Ready.Clear();
            var InProcessitems = _entities.Orders.Where(c => c.stat == 2); 
            var Readyitems = _entities.Orders.Where(c => c.stat == 3);
            foreach (var item in InProcessitems)
            {
                InProcess.Add(new InProcessOrders
                {
                    DbEntity = item,
                    Name= item.Users.name
                });
            }

            foreach (var item in Readyitems)
            {
                Ready.Add(new ReadyOrders 
                {                
                    DbEntity = item,
                    Name = item.Users.name
                });
            }
        }
    }

    public class InProcessOrders
    {
        public PizzaApp.Orders DbEntity { get; set; }
        public string Name { get; set; }
    }

    public class ReadyOrders
    {
        public PizzaApp.Orders DbEntity { get; set; }
        public string Name { get; set; }
    }
}
