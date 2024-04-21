const express = require('express');
const router = express.Router();
const {PrismaClient} = require('@prisma/client');

const Prisma = new PrismaClient();

router.post('/favorite', async (req,res) => {
    const isFound = await Prisma.favorites.findFirst({
        where: {
            title:req.body.title
        }
    })

    if(isFound) {
        res.send("data is already present");
    }

    const response = await Prisma.favorites.create({
        data: {
            title:req.body.title,
            rating:req.body.rating,
            imageurl:req.body.imageurl
        }
    })

    if(response) {
        res.send("data posted")
    }

})

router.get('/favorite', async (req, res) => {
    const response = await Prisma.favorites.findMany();

    if(response) {
        res.send({'movie':response})
    }
})


module.exports = router;