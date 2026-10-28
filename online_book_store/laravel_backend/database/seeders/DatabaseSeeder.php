<?php

namespace Database\Seeders;

use App\Models\Book;
use App\Models\Category;
use App\Models\Review;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Create Users
        $admin = User::firstOrCreate(
            ['email' => 'admin@example.com'],
            [
                'name' => 'System Administrator',
                'password' => Hash::make('password'),
                'phone' => '+1 555-0199',
                'address' => '100 Bookstore Headquarters, Tech City, CA',
                'role' => 'admin',
            ]
        );

        $customer = User::firstOrCreate(
            ['email' => 'user@example.com'],
            [
                'name' => 'John Reader',
                'password' => Hash::make('password'),
                'phone' => '+1 555-0142',
                'address' => '742 Evergreen Terrace, Springfield, OR',
                'role' => 'customer',
            ]
        );

        // 2. Create Categories
        $categoriesData = [
            [
                'name' => 'Fiction & Literature',
                'slug' => 'fiction-literature',
                'description' => 'Immerse yourself in gripping fiction stories, classics, and contemporary novels.',
                'image' => 'https://images.unsplash.com/photo-1476275466078-4007374efbbe?auto=format&fit=crop&q=80&w=400',
            ],
            [
                'name' => 'Sci-Fi & Fantasy',
                'slug' => 'sci-fi-fantasy',
                'description' => 'Explore distant galaxies, mythical worlds, and epic adventures beyond imagination.',
                'image' => 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&q=80&w=400',
            ],
            [
                'name' => 'Technology & Programming',
                'slug' => 'technology-programming',
                'description' => 'Master Flutter, Dart, PHP, Laravel, AI, Cloud Computing and Software Engineering.',
                'image' => 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?auto=format&fit=crop&q=80&w=400',
            ],
            [
                'name' => 'Mystery & Thriller',
                'slug' => 'mystery-thriller',
                'description' => 'Edge-of-your-seat suspense, detective crime fiction, and psychological puzzles.',
                'image' => 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?auto=format&fit=crop&q=80&w=400',
            ],
            [
                'name' => 'Self-Help & Mindset',
                'slug' => 'self-help-mindset',
                'description' => 'Transform your habits, boost productivity, and build mental resilience.',
                'image' => 'https://images.unsplash.com/photo-1499209974431-9dddcece7f88?auto=format&fit=crop&q=80&w=400',
            ],
            [
                'name' => 'Business & Finance',
                'slug' => 'business-finance',
                'description' => 'Proven strategies on investing, leadership, startups, and wealth creation.',
                'image' => 'https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?auto=format&fit=crop&q=80&w=400',
            ],
        ];

        $categories = [];
        foreach ($categoriesData as $cData) {
            $categories[$cData['slug']] = Category::firstOrCreate(['slug' => $cData['slug']], $cData);
        }

        // 3. Create Books
        $booksData = [
            [
                'category_id' => $categories['technology-programming']->id,
                'title' => 'Flutter & Dart: The Complete Mobile App Guide',
                'author' => 'Dr. Angela Yu & Maximilian',
                'isbn' => '978-0134494166',
                'description' => 'Build high-performance, beautiful native mobile and web applications using Flutter 3 and modern Dart null-safety features.',
                'price' => 44.99,
                'discount_price' => 34.99,
                'stock' => 25,
                'rating' => 4.9,
                'reviews_count' => 128,
                'image' => 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&q=80&w=600',
                'publisher' => 'O\'Reilly Media',
                'published_year' => 2024,
                'page_count' => 520,
                'is_featured' => true,
            ],
            [
                'category_id' => $categories['technology-programming']->id,
                'title' => 'Clean Code: A Handbook of Agile Software Craftsmanship',
                'author' => 'Robert C. Martin',
                'isbn' => '978-0132350884',
                'description' => 'Even bad code can function. But if code isn\'t clean, it can bring a development organization to its knees. Learn to write clean, professional code.',
                'price' => 39.99,
                'discount_price' => 29.99,
                'stock' => 18,
                'rating' => 4.8,
                'reviews_count' => 210,
                'image' => 'https://images.unsplash.com/photo-1532012164546-f432f2e3777a?auto=format&fit=crop&q=80&w=600',
                'publisher' => 'Prentice Hall',
                'published_year' => 2022,
                'page_count' => 464,
                'is_featured' => true,
            ],
            [
                'category_id' => $categories['self-help-mindset']->id,
                'title' => 'Atomic Habits',
                'author' => 'James Clear',
                'isbn' => '978-0735211292',
                'description' => 'An easy & proven way to build good habits & break bad ones. Learn how tiny changes lead to remarkable, compounding life results.',
                'price' => 27.00,
                'discount_price' => 18.99,
                'stock' => 50,
                'rating' => 4.9,
                'reviews_count' => 540,
                'image' => 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=600',
                'publisher' => 'Avery Publishing',
                'published_year' => 2021,
                'page_count' => 320,
                'is_featured' => true,
            ],
            [
                'category_id' => $categories['fiction-literature']->id,
                'title' => 'The Great Gatsby',
                'author' => 'F. Scott Fitzgerald',
                'isbn' => '978-0743273565',
                'description' => 'A quintessential classic of the Jazz Age exploring ambition, illusion, and love in 1920s Long Island.',
                'price' => 15.99,
                'discount_price' => 12.49,
                'stock' => 30,
                'rating' => 4.7,
                'reviews_count' => 88,
                'image' => 'https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&q=80&w=600',
                'publisher' => 'Scribner',
                'published_year' => 2020,
                'page_count' => 180,
                'is_featured' => false,
            ],
            [
                'category_id' => $categories['sci-fi-fantasy']->id,
                'title' => 'Dune Chronicles',
                'author' => 'Frank Herbert',
                'isbn' => '978-0441172719',
                'description' => 'Set on the desert planet Arrakis, Dune is the story of the boy Paul Atreides, who would become the mysterious man known as Muad\'Dib.',
                'price' => 22.50,
                'discount_price' => 17.50,
                'stock' => 14,
                'rating' => 4.8,
                'reviews_count' => 320,
                'image' => 'https://images.unsplash.com/photo-1506880018603-83d5b814b5a6?auto=format&fit=crop&q=80&w=600',
                'publisher' => 'Ace Books',
                'published_year' => 2021,
                'page_count' => 680,
                'is_featured' => true,
            ],
            [
                'category_id' => $categories['mystery-thriller']->id,
                'title' => 'The Silent Patient',
                'author' => 'Alex Michaelides',
                'isbn' => '978-1250301696',
                'description' => 'A shocking psychological thriller of a woman’s act of violence against her husband—and of the therapist obsessed with uncovering her motive.',
                'price' => 26.99,
                'discount_price' => null,
                'stock' => 20,
                'rating' => 4.6,
                'reviews_count' => 195,
                'image' => 'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?auto=format&fit=crop&q=80&w=600',
                'publisher' => 'Celadon Books',
                'published_year' => 2022,
                'page_count' => 336,
                'is_featured' => false,
            ],
            [
                'category_id' => $categories['business-finance']->id,
                'title' => 'The Psychology of Money',
                'author' => 'Morgan Housel',
                'isbn' => '978-0857197689',
                'description' => 'Timeless lessons on wealth, greed, and happiness doing well with money isn\'t necessarily about what you know. It\'s about how you behave.',
                'price' => 24.99,
                'discount_price' => 19.99,
                'stock' => 35,
                'rating' => 4.9,
                'reviews_count' => 410,
                'image' => 'https://images.unsplash.com/photo-1553729459-efe14ef6055d?auto=format&fit=crop&q=80&w=600',
                'publisher' => 'Harriman House',
                'published_year' => 2021,
                'page_count' => 256,
                'is_featured' => true,
            ],
            [
                'category_id' => $categories['technology-programming']->id,
                'title' => 'Designing Data-Intensive Applications',
                'author' => 'Martin Kleppmann',
                'isbn' => '978-1449373320',
                'description' => 'The big ideas behind reliable, scalable, and maintainable systems. Key architectural guide for backend developers and distributed system engineers.',
                'price' => 49.99,
                'discount_price' => 39.99,
                'stock' => 12,
                'rating' => 5.0,
                'reviews_count' => 175,
                'image' => 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&q=80&w=600',
                'publisher' => 'O\'Reilly Media',
                'published_year' => 2023,
                'page_count' => 616,
                'is_featured' => true,
            ],
            [
                'category_id' => $categories['fiction-literature']->id,
                'title' => 'To Kill a Mockingbird',
                'author' => 'Harper Lee',
                'isbn' => '978-0060935467',
                'description' => 'The unforgettable novel of a childhood in a sleepy Southern town and the crisis of conscience that rocked it.',
                'price' => 16.99,
                'discount_price' => 13.99,
                'stock' => 0, // Out of stock example for testing UI
                'rating' => 4.9,
                'reviews_count' => 240,
                'image' => 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?auto=format&fit=crop&q=80&w=600',
                'publisher' => 'Harper Perennial',
                'published_year' => 2020,
                'page_count' => 336,
                'is_featured' => false,
            ],
        ];

        foreach ($booksData as $bData) {
            $book = Book::firstOrCreate(['isbn' => $bData['isbn']], $bData);

            // Add sample review
            Review::firstOrCreate(
                [
                    'user_id' => $customer->id,
                    'book_id' => $book->id,
                ],
                [
                    'rating' => 5.0,
                    'comment' => "Brilliant read! Highly recommended for anyone interested in {$book->category->name}.",
                ]
            );
        }
    }
}
