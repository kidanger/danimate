local parts={
	{
		name="leftarm",
		sprite={x=24, y=0, w=7, h=14},
		swapwith="rightarm",
	},
	{
		name="leftleg",
		sprite={x=15, y=0, w=8, h=14},
		swapwith="rightleg",
	},
	{
		name="body",
		sprite={x=0, y=0, w=14, h=25},
	},
	{
		name="rightleg",
		sprite={x=15, y=0, w=8, h=14},
		swapwith="leftleg",
	},
	{
		name="rightarm",
		sprite={x=32, y=0, w=7, h=14},
		swapwith="leftarm",
	},
}
local animations = {
	{
		name="jump",
		loop=false,
		{
			duration=0.05,
			method='linear',
			body={
				angle=1.61,
				y=13.25,
				x=9.00,
			},
			leftleg={
				angle=1.48,
				y=29.50,
				x=10.75,
			},
			rightleg={
				angle=1.69,
				y=29.75,
				x=7.00,
			},
			rightarm={
				angle=1.89,
				y=21.00,
				x=3.75,
			},
			leftarm={
				angle=1.05,
				y=20.75,
				x=14.75,
			},
		},
		{
			duration=0.03,
			method='linear',
			body={
				angle=1.63,
				y=13.00,
				x=10.00,
			},
			leftleg={
				angle=1.62,
				y=29.25,
				x=10.50,
			},
			rightleg={
				angle=1.76,
				y=30.25,
				x=6.50,
			},
			rightarm={
				angle=2.64,
				y=18.25,
				x=0.75,
			},
			leftarm={
				angle=0.63,
				y=18.50,
				x=16.00,
			},
		},
		{
			duration=0.30,
			method='linear',
			body={
				angle=1.64,
				y=13.00,
				x=10.25,
			},
			leftleg={
				angle=1.62,
				y=29.75,
				x=10.75,
			},
			rightleg={
				angle=1.98,
				y=29.50,
				x=6.75,
			},
			rightarm={
				angle=-2.07,
				y=9.00,
				x=3.50,
			},
			leftarm={
				angle=-1.07,
				y=9.50,
				x=17.25,
			},
		},
	},
	{
		name="run",
		loop=true,
		{
			duration=0.20,
			method='linear',
			body={
				angle=1.80,
				y=13.00,
				x=11.25,
			},
			leftleg={
				angle=1.26,
				y=29.50,
				x=12.25,
			},
			rightleg={
				angle=2.31,
				y=29.25,
				x=3.25,
			},
			rightarm={
				angle=0.53,
				y=19.00,
				x=14.50,
			},
			leftarm={
				angle=2.88,
				y=18.75,
				x=5.00,
			},
		},
		{
			duration=0.20,
			method='linear',
			body={
				angle=1.84,
				y=12.75,
				x=11.25,
			},
			leftleg={
				angle=2.40,
				y=28.75,
				x=2.50,
			},
			rightleg={
				angle=1.17,
				y=29.00,
				x=11.75,
			},
			rightarm={
				angle=2.57,
				y=19.25,
				x=3.25,
			},
			leftarm={
				angle=0.38,
				y=18.75,
				x=16.50,
			},
		},
	},
	{
		name="crawl",
		loop=true,
		{
			duration=0.20,
			method='linear',
			body={
				angle=2.84,
				y=24.25,
				x=12.25,
			},
			leftleg={
				angle=1.89,
				y=30.75,
				x=4.00,
			},
			rightleg={
				angle=2.21,
				y=31.25,
				x=-1.75,
			},
			rightarm={
				angle=0.54,
				y=30.00,
				x=17.00,
			},
			leftarm={
				angle=1.77,
				y=31.00,
				x=11.00,
			},
		},
		{
			duration=0.20,
			method='linear',
			body={
				angle=2.80,
				y=23.50,
				x=12.50,
			},
			leftleg={
				angle=2.46,
				y=30.00,
				x=0.00,
			},
			rightleg={
				angle=2.06,
				y=30.75,
				x=4.25,
			},
			rightarm={
				angle=1.63,
				y=30.75,
				x=12.25,
			},
			leftarm={
				angle=0.94,
				y=29.75,
				x=19.00,
			},
		},
	},
	{
		name="still",
		loop=false,
		{
			duration=0.10,
			method='linear',
			body={
				angle=1.56,
				y=13.50,
				x=7.75,
			},
			leftleg={
				angle=1.50,
				y=30.00,
				x=11.25,
			},
			rightleg={
				angle=1.68,
				y=30.00,
				x=5.75,
			},
			rightarm={
				angle=1.82,
				y=22.50,
				x=3.50,
			},
			leftarm={
				angle=0.84,
				y=20.25,
				x=10.50,
			},
		},
	},
	{
		name="walk",
		loop=true,
		{
			duration=0.30,
			method='linear',
			body={
				angle=1.60,
				y=12.75,
				x=8.00,
			},
			leftleg={
				angle=1.16,
				y=29.23,
				x=11.37,
			},
			rightleg={
				angle=2.03,
				y=29.25,
				x=4.50,
			},
			rightarm={
				angle=1.11,
				y=21.25,
				x=10.50,
			},
			leftarm={
				angle=2.32,
				y=21.75,
				x=6.00,
			},
		},
		{
			duration=0.30,
			method='linear',
			body={
				angle=1.60,
				y=12.75,
				x=8.00,
			},
			leftleg={
				angle=2.00,
				y=29.50,
				x=4.75,
			},
			rightleg={
				angle=1.38,
				y=30.00,
				x=11.75,
			},
			rightarm={
				angle=1.82,
				y=20.75,
				x=4.50,
			},
			leftarm={
				angle=1.01,
				y=20.25,
				x=12.00,
			},
		},
	},
	{
		name="crouch",
		loop=false,
		{
			duration=0.10,
			method='linear',
			body={
				angle=2.65,
				y=24.00,
				x=12.00,
			},
			leftleg={
				angle=1.42,
				y=31.75,
				x=5.75,
			},
			rightleg={
				angle=2.31,
				y=31.75,
				x=1.25,
			},
			rightarm={
				angle=1.53,
				y=32.50,
				x=10.00,
			},
			leftarm={
				angle=1.04,
				y=31.50,
				x=13.75,
			},
		},
	},
	{
		name="dead",
		loop=false,
		{
			duration=0.10,
			method='linear',
			body={
				angle=1.94,
				y=13.75,
				x=9.75,
			},
			leftleg={
				angle=0.00,
				y=30.50,
				x=16.25,
			},
			rightleg={
				angle=1.68,
				y=31.00,
				x=1.25,
			},
			rightarm={
				angle=3.05,
				y=18.25,
				x=-5.50,
			},
			leftarm={
				angle=1.53,
				y=21.25,
				x=23.75,
			},
		},
		{
			duration=0.10,
			method='linear',
			body={
				angle=2.57,
				y=23.25,
				x=12.75,
			},
			leftleg={
				angle=-0.11,
				y=34.50,
				x=15.25,
			},
			rightleg={
				angle=2.86,
				y=34.00,
				x=0.75,
			},
			rightarm={
				angle=-2.24,
				y=31.50,
				x=-8.25,
			},
			leftarm={
				angle=2.28,
				y=31.25,
				x=25.50,
			},
		},
		{
			duration=0.10,
			method='linear',
			body={
				angle=3.07,
				y=31.25,
				x=11.00,
			},
			leftleg={
				angle=-0.11,
				y=34.50,
				x=15.25,
			},
			rightleg={
				angle=2.86,
				y=34.00,
				x=0.75,
			},
			rightarm={
				angle=-2.94,
				y=35.50,
				x=-7.50,
			},
			leftarm={
				angle=2.98,
				y=34.50,
				x=25.75,
			},
		},
	},
	{
		name="doublejump",
		loop=false,
		{
			duration=0.05,
			method='linear',
			body={
				angle=1.82,
				y=12.25,
				x=11.75,
			},
			leftleg={
				angle=2.25,
				y=27.50,
				x=9.75,
			},
			rightleg={
				angle=2.36,
				y=26.25,
				x=5.25,
			},
			rightarm={
				angle=2.71,
				y=18.25,
				x=3.25,
			},
			leftarm={
				angle=1.41,
				y=21.50,
				x=14.00,
			},
		},
		{
			duration=0.05,
			method='linear',
			body={
				angle=2.61,
				y=18.00,
				x=15.00,
			},
			leftleg={
				angle=2.73,
				y=27.75,
				x=6.75,
			},
			rightleg={
				angle=2.91,
				y=22.75,
				x=1.75,
			},
			rightarm={
				angle=-2.79,
				y=13.50,
				x=5.75,
			},
			leftarm={
				angle=1.98,
				y=28.50,
				x=10.75,
			},
		},
		{
			duration=0.10,
			method='linear',
			body={
				angle=-2.96,
				y=19.50,
				x=13.75,
			},
			leftleg={
				angle=-1.79,
				y=15.00,
				x=1.00,
			},
			rightleg={
				angle=-1.65,
				y=7.50,
				x=5.75,
			},
			rightarm={
				angle=-0.95,
				y=11.75,
				x=15.00,
			},
			leftarm={
				angle=3.03,
				y=25.50,
				x=7.25,
			},
		},
		{
			duration=0.10,
			method='linear',
			body={
				angle=-1.38,
				y=20.75,
				x=11.00,
			},
			leftleg={
				angle=-1.40,
				y=6.25,
				x=10.75,
			},
			rightleg={
				angle=-0.73,
				y=7.00,
				x=16.50,
			},
			rightarm={
				angle=0.17,
				y=18.00,
				x=18.75,
			},
			leftarm={
				angle=-2.72,
				y=17.50,
				x=5.25,
			},
		},
		{
			duration=0.10,
			method='linear',
			body={
				angle=-0.07,
				y=17.50,
				x=6.50,
			},
			leftleg={
				angle=0.32,
				y=14.75,
				x=18.25,
			},
			rightleg={
				angle=0.55,
				y=20.50,
				x=18.25,
			},
			rightarm={
				angle=0.97,
				y=24.50,
				x=12.50,
			},
			leftarm={
				angle=-2.78,
				y=12.25,
				x=6.50,
			},
		},
		{
			duration=0.10,
			method='linear',
			body={
				angle=1.50,
				y=11.00,
				x=9.25,
			},
			leftleg={
				angle=1.03,
				y=25.25,
				x=14.25,
			},
			rightleg={
				angle=1.63,
				y=25.50,
				x=9.50,
			},
			rightarm={
				angle=1.67,
				y=21.00,
				x=4.50,
			},
			leftarm={
				angle=0.32,
				y=15.25,
				x=15.50,
			},
		},
	},
	{
		name="falling",
		loop=true,
		{
			duration=0.10,
			method='linear',
			body={
				angle=1.64,
				y=13.00,
				x=10.25,
			},
			leftleg={
				angle=1.45,
				y=29.00,
				x=12.50,
			},
			rightleg={
				angle=1.96,
				y=29.50,
				x=6.75,
			},
			rightarm={
				angle=2.68,
				y=17.75,
				x=1.50,
			},
			leftarm={
				angle=0.74,
				y=19.00,
				x=19.25,
			},
		},
		{
			duration=0.10,
			method='linear',
			body={
				angle=1.57,
				y=13.00,
				x=10.25,
			},
			leftleg={
				angle=1.42,
				y=29.50,
				x=13.50,
			},
			rightleg={
				angle=1.80,
				y=29.75,
				x=8.25,
			},
			rightarm={
				angle=-2.90,
				y=15.00,
				x=2.00,
			},
			leftarm={
				angle=-0.10,
				y=15.50,
				x=20.00,
			},
		},
	},
}
return {
	sprite={w=16, h=37},
	parts=parts,
	animations=animations
}
