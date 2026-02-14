using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
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
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace PizzaApp
{
    /// <summary>
    /// Логика взаимодействия для CartView.xaml
    /// </summary>
    public partial class CartView : UserControl, INotifyPropertyChanged
    {
        public event EventHandler CartChanged;

        public PizzaTestEntities _dbContext;
        public ObservableCollection<CartDisplayItem> CartItems { get; set; } = new ObservableCollection<CartDisplayItem>();
        public decimal TotalCost => CartItems.Sum(i => i.TotalItemPrice);

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged(string name) => PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
        public CartView()
        {
            InitializeComponent();
            DataContext = this;
            CartItems.CollectionChanged += (_, __) =>OnPropertyChanged(nameof(TotalCost));
        }

        public void InitializeContext(PizzaTestEntities context)
        {
            _dbContext = context;
            CartItems.Clear();
            IsEmpty();
            LoadData();
        }




        private void LoadData()
        {
            int userId = MainWindow.CurrentUserId;

            var dbItems = _dbContext.Cart.Where(c => c.id_user == userId).ToList();

            foreach (var item in dbItems)
            {

                var displayItem = new CartDisplayItem
                {
                    DbEntity = item,
                    ProductName = item.Products.name,
                    Quantity = item.count ?? 0,
                    Price = item.Products?.price ?? 0,
                };

                displayItem.PropertyChanged += (_, __) => OnPropertyChanged(nameof(TotalCost));

                CartItems.Add(displayItem);
            }

        }

        private void PlusBt_Click(object sender, RoutedEventArgs e)
        {

            var button = sender as Button;
            var item = button.DataContext as CartDisplayItem;

            if (item != null)
            {
                item.Quantity++;
                _dbContext.SaveChanges();
            }
            CartChanged?.Invoke(this, EventArgs.Empty);
        }

        private void MinusBt_Click(object sender, RoutedEventArgs e)
        {

            var button = sender as Button;
            var item = button.DataContext as CartDisplayItem;

            if (item != null)
            {
                item.Quantity--;

                if (item.Quantity == 0)
                {
                    _dbContext.Cart.Remove(item.DbEntity);
                    _dbContext.SaveChanges();

                    CartItems.Remove(item);
                    IsEmpty();
                }

                _dbContext.SaveChanges();
            }
            CartChanged?.Invoke(this, EventArgs.Empty);

        }

        private void RemoveBt_Click(object sender, RoutedEventArgs e)
        {
            var item = (sender as Button)?.DataContext as CartDisplayItem;
            if (item != null)
            {

                _dbContext.Cart.Remove(item.DbEntity);
                _dbContext.SaveChanges();

                CartItems.Remove(item);
            }
            CartChanged?.Invoke(this, EventArgs.Empty);
            IsEmpty();
        }

        public void IsEmpty()
        {
            int userId = MainWindow.CurrentUserId;
            var dbItems = _dbContext.Cart.Where(c => c.id_user == userId).ToList();

            if (dbItems.Any())
            {
                IsEmptyLb.Visibility = Visibility.Collapsed;
                CreateOrderBt.Visibility = Visibility.Visible;
            }
            else
            {              
                IsEmptyLb.Visibility = Visibility.Visible;
                CreateOrderBt.Visibility = Visibility.Collapsed;
            }
        }

        private void CreateOrderBt_Click(object sender, RoutedEventArgs e)
        {
            if (_dbContext.Cart.Count() == 0)
                return;

            var order = new Orders
            {
                dateorder = DateTime.Now,
                id_user = MainWindow.CurrentUserId,
                stat = 1,
                total = _dbContext.Cart.Where(c => c.id_user == MainWindow.CurrentUserId).Sum(c => (int?)c.count * c.Products.price) ?? 0
            };
            _dbContext.Orders.Add(order);
            _dbContext.SaveChanges();

            foreach (var item in _dbContext.Cart.Where(c => c.id_user == MainWindow.CurrentUserId).ToList())
            {
                _dbContext.OrderItem.Add(new OrderItem
                {
                    id_tov = item.id_tov,
                    id_zak = order.id,
                    count = item.count
                });
                _dbContext.Cart.Remove(item);
            }
            _dbContext.SaveChanges();
            CartItems.Clear();
            CartChanged?.Invoke(this, EventArgs.Empty);


            MessageBox.Show("Заказ создан");
        }



        public class CartDisplayItem : INotifyPropertyChanged
        {
            public PizzaApp.Cart DbEntity { get; set; }
            public string ProductName { get; set; }
            public int _quantity { get; set; }
            public decimal Price { get; set; }

            public int Quantity
            {
                get => _quantity;
                set
                {
                    if (_quantity != value)
                    {
                        _quantity = value;
                        
                        if (DbEntity != null) DbEntity.count = value;

                        OnPropertyChanged(nameof(Quantity));
                        OnPropertyChanged(nameof(TotalItemPrice));
                        
                    }
                }
            }

            public decimal TotalItemPrice => Price * Quantity;

            public event PropertyChangedEventHandler PropertyChanged;
            protected void OnPropertyChanged(string name) =>
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));

        }
    }
}
