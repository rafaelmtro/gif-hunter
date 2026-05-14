import { NextResponse } from 'next/server';

export async function GET() {
  const apiKey = process.env.GIPHY_API_KEY;
  if (!apiKey) {
    return NextResponse.json({ error: 'GIPHY_API_KEY is not configured' }, { status: 500 });
  }

  try {
    const response = await fetch(
      `https://api.giphy.com/v1/trending/searches?api_key=${apiKey}`
    );
    const data = await response.json();
    return NextResponse.json(data);
  } catch (error) {
    return NextResponse.json({ error: 'Failed to fetch trending tags' }, { status: 500 });
  }
}
