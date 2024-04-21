-- CreateTable
CREATE TABLE "Favorites" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "rating" DECIMAL(65,30) NOT NULL,
    "imageurl" TEXT NOT NULL,

    CONSTRAINT "Favorites_pkey" PRIMARY KEY ("id")
);
