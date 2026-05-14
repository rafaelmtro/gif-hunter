import { NextResponse } from 'next/server';

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const offset = searchParams.get('offset') || '0';
  const limit = searchParams.get('limit') || '20';
  
  const apiKey = process.env.GIPHY_API_KEY;
  if (!apiKey) {
    return NextResponse.json({ error: 'GIPHY_API_KEY is not configured' }, { status: 500 });
  }

  try {
    const response = await fetch(
      `https://api.giphy.com/v1/gifs/trending?api_key=${apiKey}&limit=${limit}&offset=${offset}`
    );
    const data = await response.json();
    return NextResponse.json(data);
  } catch (error) {
    return NextResponse.json({ error: 'Failed to fetch trending gifs' }, { status: 500 });
  }
}
