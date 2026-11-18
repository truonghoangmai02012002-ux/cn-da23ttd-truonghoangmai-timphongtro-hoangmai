<?php

class HomeController extends Controller
{
    public function index(): void
    {
        $room = $this->model('Room');
        $total = $room->countAll();

        $this->view('home/index', [
            'title' => 'Trang chủ',
            'total' => $total,
        ]);
    }
}
