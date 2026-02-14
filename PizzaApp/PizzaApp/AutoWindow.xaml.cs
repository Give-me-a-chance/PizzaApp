using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace PizzaApp
{
    /// <summary>
    /// Логика взаимодействия для AutoWindow.xaml
    /// </summary>
    public partial class AutoWindow : Window
    {
        public PizzaTestEntities entities = new PizzaTestEntities();
        private bool isRegisterMode = false;
        private CancellationTokenSource feedbackCts;


        public AutoWindow()
        {
            InitializeComponent();
            SwitchBT.Content = "Ещё нет аккаунта";
            ConnectBT.Content = "Вход";
            StatusLB.Content = "Вход в аккаунт";
        }

        private void SwitchBT_Click(object sender, RoutedEventArgs e)
        {
            SwitchStatus();
        }

        private void SwitchStatus()
        {
            isRegisterMode = !isRegisterMode;
            NameLB.Visibility = isRegisterMode ? Visibility.Visible : Visibility.Collapsed;
            NameTB.Visibility = isRegisterMode ? Visibility.Visible : Visibility.Collapsed;
            PassRepeatLB.Visibility = isRegisterMode ? Visibility.Visible : Visibility.Collapsed;
            PassRepeatTB.Visibility = isRegisterMode ? Visibility.Visible : Visibility.Collapsed;
            SwitchBT.Content = isRegisterMode ? "Уже есть аккаунт" : "Ещё нет аккаунта";
            ConnectBT.Content = isRegisterMode ? "Регистрация" : "Вход";
            StatusLB.Content = isRegisterMode ? "Регистрация нового аккаунта" : "Вход в аккаунт";
        }

        private async void ConnectBT_Click(object sender, RoutedEventArgs e)
        {
            if (isRegisterMode)
                await Register();
            else
                await Auto();
        }

        private async Task Register()
        {
            bool hasEmpty = false;
            if (string.IsNullOrEmpty(MailTB.Text)) { HighlightEmptyField(MailTB); hasEmpty = true; }
            if (string.IsNullOrEmpty(PassTB.Password)) { HighlightEmptyField(PassTB); hasEmpty = true; }
            if (string.IsNullOrEmpty(PassRepeatTB.Password)) { HighlightEmptyField(PassRepeatTB); hasEmpty = true; }
            if (string.IsNullOrEmpty(NameTB.Text)) { HighlightEmptyField(NameTB); hasEmpty = true; }

            if (hasEmpty)
            {
                await ShowFeedbackAsync("Пожалуйста, заполните все поля.");
                return;
            }

            if (PassTB.Password != PassRepeatTB.Password)
            {
                HighlightEmptyField(PassTB);
                HighlightEmptyField(PassRepeatTB);
                await ShowFeedbackAsync("Пароли не совпадают.");
                return;
            }

            if (entities.Users.Any(u => u.mail == MailTB.Text))
            {
                HighlightEmptyField(MailTB);
                await ShowFeedbackAsync("Пользователь с указанной почтой уже зарегистрирован.");
                return;
            }

            Users user = new Users
            {
                mail = MailTB.Text,
                name = NameTB.Text,
                pass = PassTB.Password,
                role = 1
            };

            entities.Users.Add(user);
            entities.SaveChanges();

            MainWindow main = new MainWindow(user.id);
            main.Show();
            this.Close();
        }

        public async Task Auto()
        {
            bool hasEmpty = false;
            if (string.IsNullOrEmpty(MailTB.Text)) { HighlightEmptyField(MailTB); hasEmpty = true; }
            if (string.IsNullOrEmpty(PassTB.Password)) { HighlightEmptyField(PassTB); hasEmpty = true; }

            if (hasEmpty)
            {
                await ShowFeedbackAsync("Пожалуйста, введите почту и пароль.");
                return;
            }

            var user = entities.Users.FirstOrDefault(u => u.mail == MailTB.Text && u.pass == PassTB.Password);

            if (user != null && string.Equals(user.pass, PassTB.Password, StringComparison.Ordinal))
            {
                if (user.role == 1)
                {
                    MainWindow main = new MainWindow(user.id); // Окно пользователя
                    main.Show();
                    this.Close();
                    return;
                }
                else
                {
                    WorkerWindow worker = new WorkerWindow();  //Окно работника
                    worker.Show();
                    this.Close();
                    return;
                }
            }

                HighlightEmptyField(MailTB);
            HighlightEmptyField(PassTB);
            await ShowFeedbackAsync("Неверная почта или пароль.");
        }

        public async Task ShowFeedbackAsync(string message)
        {
            feedbackCts?.Cancel();
            feedbackCts = new CancellationTokenSource();
            var token = feedbackCts.Token;

            FeedBackLB.Content = message;
            FeedBackLB.Visibility = Visibility.Visible;
            FeedBackLB.Opacity = 1;

            FeedBackLB.BeginAnimation(UIElement.OpacityProperty, null);
            FeedBackLB.RenderTransform = new TranslateTransform();

            var transform = new TranslateTransform();
            FeedBackLB.RenderTransform = transform;

            var shake = new DoubleAnimationUsingKeyFrames
            {
                Duration = TimeSpan.FromMilliseconds(400)
            };
            shake.KeyFrames.Add(new EasingDoubleKeyFrame(0, KeyTime.FromPercent(0)));
            shake.KeyFrames.Add(new EasingDoubleKeyFrame(-5, KeyTime.FromPercent(0.1)));
            shake.KeyFrames.Add(new EasingDoubleKeyFrame(5, KeyTime.FromPercent(0.2)));
            shake.KeyFrames.Add(new EasingDoubleKeyFrame(-5, KeyTime.FromPercent(0.3)));
            shake.KeyFrames.Add(new EasingDoubleKeyFrame(5, KeyTime.FromPercent(0.4)));
            shake.KeyFrames.Add(new EasingDoubleKeyFrame(0, KeyTime.FromPercent(1.0)));

            transform.BeginAnimation(TranslateTransform.XProperty, shake);

            try
            {
                await Task.Delay(2000, token);
            }
            catch (TaskCanceledException)
            {
                return;
            }

            var fadeOut = new DoubleAnimation(1, 0, TimeSpan.FromMilliseconds(400))
            {
                EasingFunction = new QuadraticEase { EasingMode = EasingMode.EaseIn }
            };
            FeedBackLB.BeginAnimation(UIElement.OpacityProperty, fadeOut);

            try
            {
                await Task.Delay(400, token);
            }
            catch (TaskCanceledException)
            {
                return;
            }

            FeedBackLB.Visibility = Visibility.Hidden;
        }

        private void HighlightEmptyField(Control control)
        {
            var originalBrush = control.BorderBrush;
            var animBrush = new SolidColorBrush(Colors.Transparent);
            control.BorderBrush = animBrush;

            var anim = new ColorAnimation
            {
                From = Colors.Transparent,
                To = Colors.Red,
                Duration = TimeSpan.FromMilliseconds(150),
                AutoReverse = true,
                RepeatBehavior = new RepeatBehavior(3)
            };

            animBrush.BeginAnimation(SolidColorBrush.ColorProperty, anim);

            _ = Task.Delay(600).ContinueWith(_ =>
            {
                Dispatcher.Invoke(() => control.BorderBrush = originalBrush);
            });
        }
    }
}
