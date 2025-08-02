-- Supabase Setup Script for App Calma
-- Execute this script in your Supabase SQL editor

-- Enable Row Level Security
ALTER DATABASE postgres SET "app.jwt_secret" TO 'your-jwt-secret';

-- Create blog_posts table
CREATE TABLE IF NOT EXISTS blog_posts (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    author_email TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create user_progress table
CREATE TABLE IF NOT EXISTS user_progress (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    total_sessions INTEGER DEFAULT 0,
    total_time INTEGER DEFAULT 0, -- in minutes
    current_streak INTEGER DEFAULT 0,
    longest_streak INTEGER DEFAULT 0,
    last_session_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

-- Create newsletter_subscriptions table
CREATE TABLE IF NOT EXISTS newsletter_subscriptions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    subscribed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security on all tables
ALTER TABLE blog_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE newsletter_subscriptions ENABLE ROW LEVEL SECURITY;

-- RLS Policies for blog_posts
-- Anyone can read blog posts
CREATE POLICY "Anyone can read blog posts" ON blog_posts
    FOR SELECT USING (true);

-- Only admin can insert blog posts
CREATE POLICY "Admin can insert blog posts" ON blog_posts
    FOR INSERT WITH CHECK (auth.email() = 'bsmprojeto@gmail.com');

-- Only admin can update blog posts
CREATE POLICY "Admin can update blog posts" ON blog_posts
    FOR UPDATE USING (auth.email() = 'bsmprojeto@gmail.com');

-- Only admin can delete blog posts
CREATE POLICY "Admin can delete blog posts" ON blog_posts
    FOR DELETE USING (auth.email() = 'bsmprojeto@gmail.com');

-- RLS Policies for user_progress
-- Users can only see their own progress
CREATE POLICY "Users can view own progress" ON user_progress
    FOR SELECT USING (auth.uid() = user_id);

-- Users can only insert their own progress
CREATE POLICY "Users can insert own progress" ON user_progress
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can only update their own progress
CREATE POLICY "Users can update own progress" ON user_progress
    FOR UPDATE USING (auth.uid() = user_id);

-- RLS Policies for newsletter_subscriptions
-- Anyone can subscribe to newsletter
CREATE POLICY "Anyone can subscribe to newsletter" ON newsletter_subscriptions
    FOR INSERT WITH CHECK (true);

-- Only admin can view newsletter subscriptions
CREATE POLICY "Admin can view newsletter subscriptions" ON newsletter_subscriptions
    FOR SELECT USING (auth.email() = 'bsmprojeto@gmail.com');

-- Only admin can update newsletter subscriptions
CREATE POLICY "Admin can update newsletter subscriptions" ON newsletter_subscriptions
    FOR UPDATE USING (auth.email() = 'bsmprojeto@gmail.com');

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_blog_posts_created_at ON blog_posts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_user_progress_user_id ON user_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_newsletter_email ON newsletter_subscriptions(email);

-- Create admin user function (optional)
CREATE OR REPLACE FUNCTION create_admin_user()
RETURNS void AS $$
BEGIN
    -- This function can be used to ensure admin user exists
    -- You'll need to manually create the admin user in Supabase Auth
    -- with email: bsmprojeto@gmail.com and password: br102030
    RAISE NOTICE 'Please create admin user manually in Supabase Auth:';
    RAISE NOTICE 'Email: bsmprojeto@gmail.com';
    RAISE NOTICE 'Password: br102030';
END;
$$ LANGUAGE plpgsql;

-- Insert some sample blog posts (optional)
INSERT INTO blog_posts (title, content, author_email) VALUES
('Bem-vindo ao Blog do App Calma', 'Este é o primeiro post do nosso blog. Aqui você encontrará dicas de mindfulness, meditação e bem-estar.', 'bsmprojeto@gmail.com'),
('5 Técnicas de Respiração para Reduzir a Ansiedade', 'A respiração consciente é uma das ferramentas mais poderosas para acalmar a mente. Neste artigo, compartilhamos 5 técnicas simples que você pode usar a qualquer momento.', 'bsmprojeto@gmail.com'),
('Como Criar uma Rotina de Meditação', 'Estabelecer uma prática regular de meditação pode transformar sua vida. Descubra como começar e manter uma rotina consistente.', 'bsmprojeto@gmail.com')
ON CONFLICT DO NOTHING;

-- Success message
SELECT 'Supabase setup completed successfully!' as message;

