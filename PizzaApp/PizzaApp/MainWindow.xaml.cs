using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Configuration;
using System.Data.Entity;
using System.Diagnostics;
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
using System.Windows.Threading;

namespace PizzaApp
{

    public partial class MainWindow : Window
    {
        public PizzaTestEntities _entities  = new PizzaTestEntities();
      
        private List<CategoryGroup> _groupedProducts;

        public ObservableCollection<ActiveOrder> ActiveOrders { get; set; } = new ObservableCollection<ActiveOrder>();

        private readonly Dictionary<string, FrameworkElement> _categoryAnchors = new Dictionary<string, FrameworkElement>();

        private DispatcherTimer _timer;

        public static int CurrentUserId { get; private set; } //Не очень

        public MainWindow(int id)
        {

            InitializeComponent();            
            CurrentUserId = id;
            DataContext = this;
            CartView.CartChanged += (s, e) => UpdateCart();
          //  WorkerWindow.WindowChanged += (s, e) => ReloadData();
            UpdateCart();
            LoadData();
            ActualOrder();

            _timer = new DispatcherTimer            //Ну хоть так пока что....
                                                    //Грубо говоря - сверяются данные из бд каждые 5 секунд (для проверки изменения статусов)
            {
                Interval = TimeSpan.FromSeconds(5)
            };
            _timer.Tick += (s, e) => ReloadData();
            _timer.Start();

        }
        private void LoadData() //Карточки товаров
        {
            try
            {

                _groupedProducts = _entities.Categories
                    .Select(cat => new CategoryGroup
                    {
                        CategoryName = cat.name,
                        Products = _entities.Products
                            .Where(p => p.category == cat.id)
                            .ToList()
                    })
                    .ToList();


                CategoriesList.DataContext = _groupedProducts;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при загрузке данных:\n{ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        public void ReloadData()
        {
          //  MessageBox.Show("Обновил");
        //    _entities.Dispose();
            _entities = new PizzaTestEntities();
         //   LoadData();
         //   UpdateCart();
            ActualOrder();
        }

        private void AddToCart_Click(object sender, RoutedEventArgs e)
        {

            if ((sender as Button)?.DataContext is Products selectedProduct)
            {

                try
                {
                    var existingItem = _entities.Cart.FirstOrDefault(item =>
                        item.id_tov == selectedProduct.id &&
                        item.id_user == CurrentUserId);

                    if (existingItem != null)
                    {
                        existingItem.count++;
                    }
                    else
                    {
                        var newCartItem = new Cart
                        {
                            id_tov = selectedProduct.id,
                            count = 1,
                            id_user = CurrentUserId
                        };

                        _entities.Cart.Add(newCartItem);
                    }
                    
                    _entities.SaveChanges();

                    MessageBox.Show($"Товар '{selectedProduct.name}' добавлен в корзину.");
                    UpdateCart();
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Ошибка при сохранении в базу данных: " + ex.Message);
                }

            }

        }

        public void UpdateCart() //После измений в корзине - общая сумма пересчитывается
        {

            decimal? totalPrice = _entities.Cart
                .Where(cartItem => cartItem.id_user == CurrentUserId)
                .Join(
                    _entities.Products,
                    cartItem => cartItem.id_tov,
                    product => product.id,
                    (cartItem, product) => new {
                        Quantity = cartItem.count,
                        Price = product.price
                    }
                )
                .Sum(item => (decimal?)item.Quantity * item.Price) ?? 0m;

            CartTb.Text = totalPrice.ToString() + " ₽";
        }

        private void CartBt_Click(object sender, RoutedEventArgs e)
        {
            CartView.InitializeContext(new PizzaTestEntities()); //Передаем экземпляр БД юзерконтролу
            bool isVisible = CartView.Visibility == Visibility.Visible;

            if (isVisible)
            {
                CartView.Visibility = Visibility.Collapsed;
                Overlay.Visibility = Visibility.Collapsed;
            }
            else
            {
                CartView.Visibility = Visibility.Visible;
                Overlay.Visibility = Visibility.Visible;
            }

        }

        private void Overlay_MouseDown(object sender, MouseButtonEventArgs e) //При нажатии вне корзины или вне истории - юзерконтролы закрываются
        {
            CartView.Visibility = Visibility.Collapsed;
            Overlay.Visibility = Visibility.Collapsed;
            HistoryView.Visibility = Visibility.Collapsed;
            ActualOrder();
        }

        private void HistoryBt_Click(object sender, RoutedEventArgs e)
        {
            HistoryView.Visibility = Visibility.Visible;
            Overlay.Visibility= Visibility.Visible;
            HistoryView.InitializeContext( _entities);
        }


        private void ActualOrder()
        {

            ActiveOrders.Clear();

            var activeOrder = _entities.Orders.Where(o =>o.id_user == CurrentUserId && o.stat < 4).ToList();

            /*    if (activeOrder == null) // Лист никогда не возвращает null как оказалось
                {
                    OrderStatusPanel.Visibility = Visibility.Collapsed;
                    return;
                }
            */

            if (!activeOrder.Any()) 
            {
                OrderStatusPanel.Visibility = Visibility.Collapsed; 
                return;
            }

            OrderStatusPanel.Visibility = Visibility.Visible; //Отображается только если есть активный заказ

            foreach (var order in activeOrder)
            {
                ActiveOrders.Add(new ActiveOrder
                {
                    DbEntity = order,
                    Id = order.id,
                    Status = order.Statuses.descr,
                    BrushStatus = SetBrush(order.stat)
                    
                });
               
            }
        }

        public Brush SetBrush(int? id) //цвета
        {
            switch (id)
            {
                case 1: return Brushes.Gray;
                case 2: return Brushes.GreenYellow;
                case 3: return Brushes.LightGreen;
                case 4: return Brushes.DarkGreen;
                case 5: return Brushes.Red;
            }
            return null;
        }

        private void CategoryPanel_Loaded(object sender, RoutedEventArgs e) 
        {
            if (sender is FrameworkElement fe &&
                fe.Tag is CategoryGroup category &&
                !_categoryAnchors.ContainsKey(category.CategoryName))
            {
                _categoryAnchors.Add(category.CategoryName, fe);
            }
        }

        private void Category_Click(object sender, RoutedEventArgs e) //Навигация по категориям
        {
            if (sender is Button btn &&
                btn.Tag is string categoryName &&
                _categoryAnchors.TryGetValue(categoryName, out var element))
            {
                element.BringIntoView();
            }
        }

    }
    public class CategoryGroup
    {
        public string CategoryName { get; set; }
        public List<Products> Products { get; set; }
    }


    public class ActiveOrder
    {
        public PizzaApp.Orders DbEntity { get; set; }
        public int Id { get; set; }
        public string Status { get; set; }
        public Brush BrushStatus { get; set; }
    }
}

